# frozen_string_literal: true

require "rails_helper"

RSpec.describe Alchemy::StorageAdapter::Dragonfly::CloudinaryUrl do
  let(:image_file) { double("image_file", remote_url: "https://cloudinary.com/image.jpg") }
  let(:picture) { double("picture", image_file: image_file) }
  let(:url_generator) { described_class.new(picture) }

  describe "#call" do
    context "without any options" do
      it "returns the remote URL with secure option" do
        expect(image_file).to receive(:remote_url).with(
          transformation: [],
          secure: true
        )
        url_generator.call
      end
    end

    context "with size option only" do
      it "returns the remote URL with resize transformation" do
        expect(image_file).to receive(:remote_url).with(
          transformation: [{crop: "limit", size: "300x200"}],
          secure: true
        )
        url_generator.call(size: "300x200")
      end
    end

    context "with size and upsample options" do
      it "uses fit crop mode" do
        expect(image_file).to receive(:remote_url).with(
          transformation: [{crop: "fit", size: "300x200"}],
          secure: true
        )
        url_generator.call(size: "300x200", upsample: true)
      end
    end

    context "with crop options" do
      let(:options) do
        {
          crop: true,
          crop_from: "10x20",
          crop_size: "100x80",
          size: "300x200"
        }
      end

      it "returns the remote URL with crop and resize transformations" do
        expect(image_file).to receive(:remote_url).with(
          transformation: [
            {
              crop: "crop",
              gravity: "xy_center",
              x: 60,
              y: 60,
              size: "100x80"
            },
            {
              crop: "fill",
              size: "300x200"
            }
          ],
          secure: true
        )
        url_generator.call(options)
      end
    end

    context "with crop option but no crop_from" do
      it "does not include crop transformation" do
        expect(image_file).to receive(:remote_url).with(
          transformation: [{crop: "fill", size: "300x200"}],
          secure: true
        )
        url_generator.call(crop: true, size: "300x200")
      end
    end

    context "with crop_from as blank string" do
      it "does not include crop transformation" do
        expect(image_file).to receive(:remote_url).with(
          transformation: [{crop: "fill", size: "300x200"}],
          secure: true
        )
        url_generator.call(crop: true, crop_from: "", size: "300x200")
      end
    end
  end

  describe "#crop_coordinates" do
    subject { url_generator.send(:crop_coordinates) }

    before do
      url_generator.call(crop_from: crop_from, crop_size: crop_size)
    end

    context "with integer coordinates" do
      let(:crop_from) { "10x20" }
      let(:crop_size) { "100x80" }

      it "calculates center point correctly" do
        expect(subject).to eq({x: 60, y: 60})
      end
    end

    context "with zero coordinates" do
      let(:crop_from) { "0x0" }
      let(:crop_size) { "50x50" }

      it "calculates center point correctly" do
        expect(subject).to eq({x: 25, y: 25})
      end
    end

    context "with decimal crop sizes" do
      let(:crop_from) { "10x10" }
      let(:crop_size) { "99x99" }

      it "rounds the center point" do
        expect(subject).to eq({x: 60, y: 60})
      end
    end
  end

  describe "#crop_mode" do
    subject { url_generator.send(:crop_mode) }

    before do
      url_generator.call(options)
    end

    context "when crop is true" do
      let(:options) { {crop: true} }

      it "returns fill" do
        expect(subject).to eq("fill")
      end
    end

    context "when crop is false and upsample is true" do
      let(:options) { {crop: false, upsample: true} }

      it "returns fit" do
        expect(subject).to eq("fit")
      end
    end

    context "when crop is false and upsample is false" do
      let(:options) { {crop: false, upsample: false} }

      it "returns limit" do
        expect(subject).to eq("limit")
      end
    end

    context "when no options provided" do
      let(:options) { {} }

      it "returns limit" do
        expect(subject).to eq("limit")
      end
    end
  end

  describe "#crop_transformation" do
    subject { url_generator.send(:crop_transformation) }

    before do
      url_generator.call(options)
    end

    context "with all crop parameters" do
      let(:options) do
        {
          crop: true,
          crop_from: "100x200",
          crop_size: "300x400"
        }
      end

      it "returns crop transformation hash" do
        expect(subject).to eq(
          {
            crop: "crop",
            gravity: "xy_center",
            x: 250,
            y: 400,
            size: "300x400"
          }
        )
      end
    end

    context "without crop option" do
      let(:options) { {crop_from: "100x200", crop_size: "300x400"} }

      it "returns nil" do
        expect(subject).to be_nil
      end
    end

    context "without crop_from" do
      let(:options) { {crop: true, crop_size: "300x400"} }

      it "returns nil" do
        expect(subject).to be_nil
      end
    end
  end

  describe "#resize_transformation" do
    subject { url_generator.send(:resize_transformation) }

    before do
      url_generator.call(options)
    end

    context "with size option" do
      let(:options) { {size: "300x200"} }

      it "returns resize transformation hash" do
        expect(subject).to eq(
          {
            crop: "limit",
            size: "300x200"
          }
        )
      end
    end

    context "with size and crop options" do
      let(:options) { {size: "300x200", crop: true} }

      it "returns resize transformation with fill crop mode" do
        expect(subject).to eq(
          {
            crop: "fill",
            size: "300x200"
          }
        )
      end
    end

    context "without size option" do
      let(:options) { {} }

      it "returns nil" do
        expect(subject).to be_nil
      end
    end
  end

  describe "#transformations" do
    subject { url_generator.send(:transformations) }

    before do
      url_generator.call(options)
    end

    context "with both crop and resize transformations" do
      let(:options) do
        {
          crop: true,
          crop_from: "10x20",
          crop_size: "100x80",
          size: "300x200"
        }
      end

      it "returns both transformations in order" do
        expect(subject).to eq([
          {
            crop: "crop",
            gravity: "xy_center",
            x: 60,
            y: 60,
            size: "100x80"
          },
          {
            crop: "fill",
            size: "300x200"
          }
        ])
      end
    end

    context "with only resize transformation" do
      let(:options) { {size: "300x200"} }

      it "returns only resize transformation" do
        expect(subject).to eq([
          {
            crop: "limit",
            size: "300x200"
          }
        ])
      end
    end

    context "with no transformations" do
      let(:options) { {} }

      it "returns empty array" do
        expect(subject).to eq([])
      end
    end
  end
end

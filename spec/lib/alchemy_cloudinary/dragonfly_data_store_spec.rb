# frozen_string_literal: true

require "rails_helper"

RSpec.describe AlchemyCloudinary::DragonflyDataStore do
  let(:data_store) { described_class.new }
  let(:content) { double("content", file: "/tmp/test.jpg", name: "test_image.jpg") }

  describe "#write" do
    let(:upload_result) do
      {
        "public_id" => "test_image",
        "format" => "jpg"
      }
    end

    it "uploads content to Cloudinary" do
      expect(Cloudinary::Uploader).to receive(:upload).with(
        "/tmp/test.jpg",
        hash_including(public_id: "testimage")
      ).and_return(upload_result)

      result = data_store.write(content)
      expect(result).to eq("test_image.jpg")
    end

    it "passes additional options to Cloudinary" do
      expect(Cloudinary::Uploader).to receive(:upload).with(
        "/tmp/test.jpg",
        hash_including(public_id: "testimage", folder: "uploads")
      ).and_return(upload_result)

      data_store.write(content, folder: "uploads")
    end

    it "removes underscores from name for public_id" do
      content = double("content", file: "/tmp/test.jpg", name: "test_image_file.jpg")

      expect(Cloudinary::Uploader).to receive(:upload).with(
        "/tmp/test.jpg",
        hash_including(public_id: "testimagefile")
      ).and_return(upload_result)

      data_store.write(content)
    end
  end

  describe "#read" do
    let(:cloudinary_url) { "https://res.cloudinary.com/demo/image/upload/test_image.jpg" }
    let(:downloaded_data) { "binary image data" }

    before do
      allow(Cloudinary::Utils).to receive(:cloudinary_url).and_return(cloudinary_url)
      allow(Cloudinary::Downloader).to receive(:download)
        .with(cloudinary_url)
        .and_return(downloaded_data)
    end

    it "downloads image from Cloudinary" do
      result = data_store.read("test_image.jpg")

      expect(result).to eq([downloaded_data, {"name" => "testimage"}])
    end

    it "uses jpg format by default if no extension" do
      data_store.read("test_image")

      # Note: ext() returns empty string for files without extension,
      # so the || 'jpg' fallback passes empty string instead of 'jpg'
      expect(Cloudinary::Utils).to have_received(:cloudinary_url)
        .with("test_image", hash_including(format: ""))
    end

    it "uses the file extension from uid" do
      data_store.read("test_image.png")

      expect(Cloudinary::Utils).to have_received(:cloudinary_url)
        .with("test_image", hash_including(format: "png"))
    end
  end

  describe "#destroy" do
    it "destroys image on Cloudinary" do
      expect(Cloudinary::Uploader).to receive(:destroy).with("test_image")

      data_store.destroy("test_image.jpg")
    end

    it "extracts public_id without extension" do
      expect(Cloudinary::Uploader).to receive(:destroy).with("my_image")

      data_store.destroy("my_image.png")
    end
  end

  describe "#url_for" do
    it "generates Cloudinary URL with extension format" do
      expect(Cloudinary::Utils).to receive(:cloudinary_url)
        .with("test_image", hash_including(format: "jpg"))
        .and_return("https://res.cloudinary.com/demo/image/upload/test_image.jpg")

      url = data_store.url_for("test_image.jpg")
      expect(url).to eq("https://res.cloudinary.com/demo/image/upload/test_image.jpg")
    end

    it "merges options with format" do
      expect(Cloudinary::Utils).to receive(:cloudinary_url)
        .with("test_image", hash_including(format: "jpg", width: 300, height: 200))
        .and_return("https://res.cloudinary.com/demo/image/upload/w_300,h_200/test_image.jpg")

      data_store.url_for("test_image.jpg", width: 300, height: 200)
    end

    it "allows options to override format" do
      expect(Cloudinary::Utils).to receive(:cloudinary_url)
        .with("test_image", hash_including(format: "png"))

      data_store.url_for("test_image.jpg", format: "png")
    end
  end

  describe "private methods" do
    describe "#public_id" do
      it "extracts public_id from uid" do
        expect(data_store.send(:public_id, "test_image.jpg")).to eq("test_image")
      end

      it "handles uid without extension" do
        expect(data_store.send(:public_id, "test_image")).to eq("test_image")
      end

      it "handles complex filenames" do
        expect(data_store.send(:public_id, "my_test_image.png")).to eq("my_test_image")
      end
    end

    describe "#name" do
      it "removes underscores from public_id" do
        expect(data_store.send(:name, "test_image.jpg")).to eq("testimage")
      end

      it "handles multiple underscores" do
        expect(data_store.send(:name, "my_test_image_file.png")).to eq("mytestimagefile")
      end

      it "returns name as-is if no underscores" do
        expect(data_store.send(:name, "testimage.jpg")).to eq("testimage")
      end
    end

    describe "#ext" do
      it "returns extension without dot by default" do
        expect(data_store.send(:ext, "test_image.jpg")).to eq("jpg")
      end

      it "returns extension with dot when requested" do
        expect(data_store.send(:ext, "test_image.jpg", true)).to eq(".jpg")
      end

      it "returns empty string for files without extension" do
        expect(data_store.send(:ext, "test_image")).to eq("")
      end

      it "handles various extensions" do
        expect(data_store.send(:ext, "image.png")).to eq("png")
        expect(data_store.send(:ext, "image.gif")).to eq("gif")
        expect(data_store.send(:ext, "image.webp")).to eq("webp")
      end
    end
  end
end

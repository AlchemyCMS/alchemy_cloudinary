# frozen_string_literal: true

require "rails_helper"

RSpec.describe AlchemyCloudinary::StorePictureThumb do
  describe ".call" do
    it "is a no-op that returns nil" do
      result = described_class.call("arg1", "arg2", "arg3")
      expect(result).to be_nil
    end

    it "accepts any arguments without error" do
      expect { described_class.call }.not_to raise_error
      expect { described_class.call(1, 2, 3) }.not_to raise_error
      expect { described_class.call(foo: "bar") }.not_to raise_error
    end

    it "does not perform any operations" do
      # Verify no external calls are made
      expect(described_class.call).to be_nil
    end
  end
end

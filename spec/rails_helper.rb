# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require "spec_helper"

# Load only the ActiveSupport extension we need for .present?
require "active_support/core_ext/object/blank"

# Define namespace structure
module Alchemy
  class StorageAdapter
    module Dragonfly
    end
  end
end

# Add Alchemy CMS app directory to load path
gem_path = Gem::Specification.find_by_name("alchemy_cms").gem_dir
$LOAD_PATH.unshift(File.join(gem_path, "app/models"))

# Load just the Alchemy picture URL class we need
require "alchemy/storage_adapter/dragonfly/picture_url"

# Now load our CloudinaryUrl class
require_relative "../app/models/alchemy/storage_adapter/dragonfly/cloudinary_url"

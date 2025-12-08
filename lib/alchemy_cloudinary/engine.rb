# frozen_string_literal: true

module AlchemyCloudinary
  class Engine < ::Rails::Engine
    config.before_initialize do
      require "dragonfly"
      require "alchemy_cloudinary/dragonfly_data_store"

      Dragonfly::App.register_datastore(:alchemy_cloudinary) do
        AlchemyCloudinary::DragonflyDataStore
      end
    end

    config.to_prepare do
      # require_dependency "alchemy/picture/cloudinary_url"
      # require_dependency "alchemy_cloudinary/store_picture_thumb"
      Alchemy.config.storage_adapter = "dragonfly"
      Alchemy::StorageAdapter::Dragonfly.picture_url_class = Alchemy::StorageAdapter::Dragonfly::CloudinaryUrl
      # Alchemy::Picture.url_class = Alchemy::Picture::CloudinaryUrl
      # Alchemy::PictureThumb.storage_class = AlchemyCloudinary::StorePictureThumb
    end
  end
end

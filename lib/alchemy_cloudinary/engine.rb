# frozen_string_literal: true

module AlchemyCloudinary
  class Engine < ::Rails::Engine
    config.before_initialize do
      require 'dragonfly'
      require 'alchemy_cloudinary/dragonfly_data_store'

      Dragonfly::App.register_datastore(:alchemy_cloudinary) do
        AlchemyCloudinary::DragonflyDataStore
      end
    end

    config.to_prepare do
      file = 'alchemy/picture/cloudinary_url'
      Rails.configuration.cache_classes ? require(file) : load(file)
      Alchemy::Picture.prepend(Alchemy::Picture::CloudinaryUrl)
    end
  end
end

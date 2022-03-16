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
      require_dependency 'alchemy/picture/cloudinary_url'
      Alchemy::Picture.prepend(Alchemy::Picture::CloudinaryUrl)
    end
  end
end

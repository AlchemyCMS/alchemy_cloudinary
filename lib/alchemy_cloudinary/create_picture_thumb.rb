module AlchemyCloudinary
  class CreatePictureThumb
    def self.call(*)
      # make this noop, because we do not want to create thumbnails,
      # since Cloudinary renders image thumbnails on demand
    end
  end
end

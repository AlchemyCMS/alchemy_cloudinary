module AlchemyCloudinary
  class StorePictureThumb
    def self.call(*)
      # make this noop, because we do not want to store thumbnails,
      # since Cloudinary renders image thumbnails on demand
    end
  end
end

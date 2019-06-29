# frozen_string_literal: true

module Alchemy
  module Picture::CloudinaryUrl
    def url(options = {})
      @options = options
      image_file.remote_url(transformation: transformations, secure: !!options[:secure])
    end

    private

    def transformations
      [crop_transformation, resize_transformation].compact
    end

    def crop_transformation
      if @options[:crop] && @options[:crop_from].present?
        {
          crop: 'crop',
          gravity: 'xy_center',
          x: crop_coordinates[:x],
          y: crop_coordinates[:y],
          size: @options[:crop_size]
        }
      end
    end

    def resize_transformation
      crop_mode = @options[:crop] ? 'fill' : @options[:upsample] ? 'fit' : 'limit'
      if @options[:size]
        {
          crop: crop_mode,
          size: @options[:size]
        }
      end
    end

    def crop_coordinates
      x, y = @options[:crop_from].to_s.split('x')
      size_x, size_y = @options[:crop_size].to_s.split('x')
      {
        x: (x.to_i + size_x.to_f / 2).round,
        y: (y.to_i + size_y.to_f / 2).round
      }
    end
  end
end

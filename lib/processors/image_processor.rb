# frozen_string_literal: true

require_relative 'base_processor'
module FileProcessor
  # Processor for image files
  class ImageProcessor < BaseProcessor
    def extract_preview
      image = MiniMagick::Image.new(@file)
      image.resize(PREVIEW_RESOLUTION)

      image
    end
  end
end

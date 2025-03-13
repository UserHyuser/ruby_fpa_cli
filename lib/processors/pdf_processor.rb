# frozen_string_literal: true

require_relative 'base_processor'

module FileProcessor
  # Processor for PDF files
  class PdfProcessor < BaseProcessor
    def extract_preview
      image = MiniMagick::Image.open(@file)
      image.format('png')
      image.resize(PREVIEW_RESOLUTION)
      image
    end

    def extract_text
      reader = PDF::Reader.new(@file)

      reader.pages.map(&:text).join("\n")
    end
  end
end

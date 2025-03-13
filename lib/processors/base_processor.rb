# frozen_string_literal: true

require 'mini_magick'
require 'pdf-reader'

module FileProcessor
  # Abstract class for file processors
  class BaseProcessor
    PREVIEW_RESOLUTION = '400x400'

    def initialize(file)
      @file = file
    end

    def extract_and_save_preview
      with_operation_logging(:preview, generate_output_filename('.preview.png')) do |output_file|
        extract_preview.write(output_file)
      end
    end

    def extract_and_save_text
      with_operation_logging(:text, generate_output_filename('.txt')) do |output_file|
        File.write(output_file, extract_text)
      end
    end

    protected

    # Create instance of image
    # @return [MiniMagick::Image]
    def make_preview
      raise NotImplementedError, 'Subclasses must implement extract_preview'
    end

    # Extract text from file
    # @return [String]
    def extract_text
      raise NotImplementedError, 'Subclasses must implement extract_text'
    end

    private

    def with_operation_logging(operation_type, output_file)
      yield(output_file)

      log_success(operation_type, output_file)
      output_file
    rescue StandardError => e
      log_error(operation_type, e)
      raise
    end

    def generate_output_filename(extension)
      "#{File.basename(@file, '.*')}#{extension}"
    end

    def log_success(operation_type, output_file)
      AppLogger.info(
        I18n.t("file_processor.operations.#{operation_type}.success"),
        { input: @file, output: output_file }
      )
    end

    def log_error(operation_type, error)
      AppLogger.error(
        I18n.t("file_processor.operations.#{operation_type}.error"),
        { input: @file, error: error.message }
      )
    end
  end
end

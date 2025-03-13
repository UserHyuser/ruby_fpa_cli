# frozen_string_literal: true

require 'optparse'
require 'mime-types'

require_relative '../../config/initializers/i18n'
require_relative '../app_logger'
require_relative '../processors/image_processor'
require_relative '../processors/pdf_processor'

module FileProcessor
  # Handler for the command line interface
  class CLI
    SUPPORTED_COMMANDS = %w[preview text all].freeze

    def initialize(argv)
      @argv = argv
      @options = { command: 'all' } # Default command is 'all'
    end

    def run
      parse_options
      validate_input_file
      process_file
    rescue StandardError => e
      handle_error(e)
    end

    private

    def parse_options
      OptionParser.new do |opts|
        opts.banner = I18n.t('cli.usage')
        opts.on('-f', '--file FILE', I18n.t('cli.options.file')) { |file| @options[:file] = file }
        opts.on('-c', '--command COMMAND', I18n.t('cli.options.command')) do |command|
          @options[:command] = command.downcase
        end
        opts.on('-h', '--help', I18n.t('cli.options.help')) do
          puts opts
          exit
        end
      end.parse!(@argv)
    end

    def validate_input_file
      raise ::I18n.t('cli.errors.file_required') unless @options[:file]
      raise ::I18n.t('cli.errors.file_not_found', file: @options[:file]) unless File.exist?(@options[:file])
    end

    def process_file
      case @options[:command]
      when 'preview' then process_preview
      when 'text' then process_text
      when 'all' then process_all
      else
        raise I18n.t('cli.errors.invalid_command', command: @options[:command])
      end
    end

    def process_preview
      if image?(@options[:file])
        ImageProcessor.new(@options[:file]).extract_and_save_preview
      elsif pdf?(@options[:file])
        PdfProcessor.new(@options[:file]).extract_and_save_preview
      else
        raise I18n.t('file_processor.errors.preview_not_supported')
      end
    end

    def process_text
      raise I18n.t('file_processor.errors.text_extraction_not_supported') unless pdf?(@options[:file])

      PdfProcessor.new(@options[:file]).extract_and_save_text
    end

    def process_all
      process_preview
      process_text
    end

    def image?(file)
      MIME::Types.type_for(file).first.media_type == 'image'
    end

    def pdf?(file)
      MIME::Types.type_for(file).first.content_type == 'application/pdf'
    end

    def handle_error(error)
      AppLogger.error(I18n.t('cli.errors.general_error', message: error.message), input: @options, error: error.class)
      puts "Error: #{error.message}"
      raise error
    end
  end
end

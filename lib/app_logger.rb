# frozen_string_literal: true

require 'logging'
require 'json'

# Custom implementation of a logger for the application
class AppLogger
  SEVERITIES = %i[info error warn debug].freeze
  LOG_FILE = './logs/app.log'

  class << self
    def initialize_logger(log_file = LOG_FILE)
      @logger = Logging.logger[log_file]
      @logger.add_appenders(
        Logging.appenders.file(
          log_file,
          layout: Logging.layouts.json,
          truncate: true, # Rotate logs
          size: 10 * 1024 * 1024, # 10MB max size
          keep: 5 # Keep 5 backups
        )
      )
    end

    # Define class methods for each severity level
    SEVERITIES.each do |severity|
      define_method(severity) do |message, context = {}|
        log(severity, message, context)
      end
    end

    private

    def log(severity, message, context)
      @logger ||= initialize_logger # Lazy initialization
      @logger.send(severity, build_log_entry(severity, message, context))
    rescue StandardError => e
      @logger.error("Failed to log: #{e.message}")
    end

    def build_log_entry(severity, message, context)
      {
        time: Time.now.utc.iso8601,
        severity: severity.to_s,
        message: message,
        context: context
      }.to_json
    end
  end
end

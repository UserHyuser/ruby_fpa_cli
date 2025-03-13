# frozen_string_literal: true

require 'i18n'

# Load all locale files from the config/locales directory
I18n.load_path += Dir[File.expand_path('config/locales') + '/*.yml']

# Set the default locale to English
I18n.default_locale = :en

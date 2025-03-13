# frozen_string_literal: true

require 'spec_helper'
require 'app_logger'

RSpec.describe AppLogger do
  let(:log_file) { './logs/test.log' }

  before do
    File.write(log_file, '')
    stub_const('AppLogger::LOG_FILE', log_file)
    AppLogger.instance_variable_set(:@logger, nil)
    allow(AppLogger).to receive(:initialize_logger).and_call_original
  end

  after do
    File.delete(log_file) if File.exist?(log_file)
  end

  describe 'logging methods' do
    %i[info error warn debug].each do |severity|
      it "logs #{severity} messages" do
        AppLogger.send(severity, 'Test message', { key: 'value' })
        log_content = begin
          JSON.parse(JSON.parse(File.read(log_file))['message'])
        rescue StandardError
          {}
        end
        expect(log_content['severity']).to eq(severity.to_s)
        expect(log_content['message']).to eq('Test message')
        expect(log_content['context']['key']).to eq('value')
      end
    end
  end
end

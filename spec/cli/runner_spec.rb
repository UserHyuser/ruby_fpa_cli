# frozen_string_literal: true

require 'spec_helper'
require 'cli/runner'

RSpec.describe FileProcessor::CLI do
  let(:valid_file) { 'sample.pdf' }
  let(:invalid_file) { 'nonexistent.pdf' }
  let(:file_double) { instance_double(File) }

  before do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with(invalid_file).and_return(false)

    allow(File).to receive(:exist?).with(valid_file).and_return(true)
    allow(File).to receive(:open).and_return(file_double)
  end

  describe '#run' do
    context 'with valid arguments' do
      let(:pdf_processor_double) do
        instance_double(
          FileProcessor::PdfProcessor,
          extract_and_save_preview: true,
          extract_and_save_text: true
        )
      end

      before do
        allow(FileProcessor::PdfProcessor).to receive(:new).with(valid_file).and_return(pdf_processor_double)
      end

      it 'processes the file' do
        cli = described_class.new(['-f', valid_file, '-c', 'all'])
        expect { cli.run }.not_to raise_error

        expect(pdf_processor_double).to have_received(:extract_and_save_preview)
      end
    end

    context 'with invalid arguments' do
      it 'raises an error for missing file' do
        cli = described_class.new(['-c', 'all'])
        expect { cli.run }.to raise_error(I18n.t('cli.errors.file_required'))
      end

      it 'raises an error for nonexistent file' do
        cli = described_class.new(['-f', invalid_file, '-c', 'all'])
        expect { cli.run }.to raise_error(I18n.t('cli.errors.file_not_found', file: invalid_file))
      end

      it 'raises an error for invalid command' do
        cli = described_class.new(['-f', valid_file, '-c', 'invalid'])
        expect { cli.run }.to raise_error(I18n.t('cli.errors.invalid_command', command: 'invalid'))
      end
    end
  end
end

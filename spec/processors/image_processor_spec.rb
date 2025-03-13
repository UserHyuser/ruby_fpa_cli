# frozen_string_literal: true

require 'spec_helper'
require 'processors/image_processor'
require 'app_logger'

RSpec.describe FileProcessor::ImageProcessor do
  let(:file_path) { 'dummy.png' }
  let(:processor) { described_class.new(file_path) }

  describe '#extract_preview' do
    let(:image_double) { double(MiniMagick::Image) }

    before do
      allow(MiniMagick::Image).to receive(:new)
        .with(file_path)
        .and_return(image_double)

      allow(image_double).to receive(:resize)
    end

    it 'resizes the image to the correct resolution' do
      result = processor.extract_preview

      expect(MiniMagick::Image).to have_received(:new).with(file_path)
      expect(image_double).to have_received(:resize).with('400x400')
      expect(result).to eq(image_double)
    end
  end

  describe '#extract_and_save_preview' do
    let(:image_double) { double('MiniMagick::Image') }
    let(:output_file) { 'dummy.preview.png' }

    before do
      allow(MiniMagick::Image).to receive(:new)
        .with(file_path)
        .and_return(image_double)

      allow(image_double).to receive(:resize)
      allow(image_double).to receive(:write)
      allow(File).to receive(:basename).with(file_path, '.*').and_return('dummy')
      allow(AppLogger).to receive(:info)
    end

    it 'creates a preview and logs the operation' do
      processor.extract_and_save_preview

      expect(MiniMagick::Image).to have_received(:new).with(file_path)
      expect(image_double).to have_received(:resize).with('400x400')
      expect(image_double).to have_received(:write).with(output_file)
      expect(AppLogger).to have_received(:info).with(
        'Preview extracted',
        { input: file_path, output: output_file }
      )
    end
  end
end

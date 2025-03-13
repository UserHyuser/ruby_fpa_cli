# frozen_string_literal: true

require 'spec_helper'
require 'processors/pdf_processor'

RSpec.describe FileProcessor::PdfProcessor do
  let(:file_path) { 'dummy.pdf' }
  let(:processor) { described_class.new(file_path) }

  describe '#extract_preview' do
    let(:image_double) { double(MiniMagick::Image) }

    before do
      allow(MiniMagick::Image).to receive(:open)
        .with(file_path)
        .and_return(image_double)

      allow(image_double).to receive(:format)
      allow(image_double).to receive(:resize)
    end

    it 'processes PDF with correct image operations' do
      result = processor.extract_preview

      expect(MiniMagick::Image).to have_received(:open).with(file_path)
      expect(image_double).to have_received(:format).with('png')
      expect(image_double).to have_received(:resize).with('400x400')
      expect(result).to eq(image_double)
    end
  end

  describe '#extract_text' do
    let(:reader_double) { instance_double(PDF::Reader) }
    let(:page_double1) { instance_double(PDF::Reader::Page, text: 'Text from page 1') }
    let(:page_double2) { instance_double(PDF::Reader::Page, text: 'Text from page 2') }

    before do
      allow(PDF::Reader).to receive(:new)
        .with(file_path)
        .and_return(reader_double)

      allow(reader_double).to receive(:pages)
        .and_return([page_double1, page_double2])
    end

    it 'extracts text from all pages' do
      result = processor.extract_text

      expect(PDF::Reader).to have_received(:new).with(file_path)
      expect(result).to eq("Text from page 1\nText from page 2")
    end
  end
end

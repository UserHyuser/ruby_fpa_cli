# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'I18n setup' do
  it 'has English as the default locale' do
    expect(I18n.default_locale).to eq(:en)
  end

  it 'translates a known key' do
    expect(I18n.t('file_processor.errors.file_not_found', file: 'test.txt')).to eq('File not found: test.txt')
  end
end

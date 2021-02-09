require 'spec_helper'

describe Admin::TranslatedRecordHelper, type: :helper do
  describe '#locale_tabs' do
    subject { helper.locale_tabs(record) }
    let(:record) { double.as_null_object }
    it { is_expected.to match(/locales nav nav-tabs/) }
  end
end

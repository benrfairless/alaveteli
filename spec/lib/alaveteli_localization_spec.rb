# -*- encoding : utf-8 -*-
require 'spec_helper'

describe AlaveteliLocalization do

  describe '.set_locales' do

    before do
      AlaveteliLocalization.set_locales('en_GB es', 'en_GB')
    end

    context 'when dealing with FastGettext' do

      it 'sets FastGettext.locale' do
        expect(FastGettext.locale).to eq("en_GB")
      end

      it 'sets FastGettext.locale correctly if given a hypheanted locale' do
        AlaveteliLocalization.set_locales('en-GB es', 'en-GB')
        expect(FastGettext.locale).to eq('en_GB')
      end

      it 'sets FastGettext.default_locale' do
        expect(FastGettext.default_locale).to eq("en_GB")
      end

      it 'sets FastGettext.default_available_locales' do
        expect(FastGettext.default_available_locales).to eq([:en_GB, :es])
      end

    end

    context 'when dealing with I18n' do

      context 'when enforce_available_locales is true' do

        before do
          I18n.config.enforce_available_locales = true
        end

        it 'allows a new locale to be set as the default' do
          AlaveteliLocalization.set_locales('nl en', 'nl')
          expect(I18n.default_locale).to eq(:nl)
        end

      end

      it 'sets I18n.locale' do
        expect(I18n.locale).to eq(:"en-GB")
      end

      it 'sets I18n.default_locale' do
        expect(I18n.default_locale).to eq(:"en-GB")
      end

      it 'sets I18n.available_locales' do
        expect(I18n.available_locales).to eq([:"en-GB", :es])
      end

    end

    it 'sets the locales for the custom routing filter' do
      expect(RoutingFilter::Conditionallyprependlocale.locales).
        to eq([:en_GB, :es])
    end

    it 'handles being passed a symbol as available_locales' do
      AlaveteliLocalization.set_locales(:es, :es)
      expect(AlaveteliLocalization.available_locales).to eq([:es])
    end

    it 'handles being passed hyphenated strings as available_locales' do
      AlaveteliLocalization.set_locales('en-GB nl-BE es', :es)
      expect(AlaveteliLocalization.available_locales).
        to eq([:"en_GB", :"nl_BE", :es])
    end

  end

  describe '.locale' do

    it 'returns the current locale' do
      expect(AlaveteliLocalization.locale).to eq(:en)
    end

    it 'returns the locale in the underscore format' do
      AlaveteliLocalization.set_locales('en_GB', 'en_GB')
      expect(AlaveteliLocalization.locale).to eq(:en_GB)
    end

  end

  describe '.default_locale' do

    it 'returns the current locale' do
      expect(AlaveteliLocalization.default_locale).to eq(:en)
    end

    it 'returns the locale in the underscore format' do
      AlaveteliLocalization.set_locales('en_GB es', 'en_GB')
      expect(AlaveteliLocalization.default_locale).to eq(:en_GB)
    end

  end

  describe '.default_locale?' do

    it 'returns true if the supplied locale is the default' do
      expect(AlaveteliLocalization.default_locale?(:en)).to eq(true)
    end

    it 'returns false if the supplied locale is not the default' do
      expect(AlaveteliLocalization.default_locale?(:es)).to eq(false)
    end

    it 'accepts string formatted locales' do
      expect(AlaveteliLocalization.default_locale?("en")).to eq(true)
    end

    it 'returns false if the supplied locale is nil' do
      expect(AlaveteliLocalization.default_locale?(nil)).to eq(false)
    end

  end

  describe '.available_locales' do

    it 'returns an array of available locales' do
      described_class.set_locales('en_GB es', 'en_GB')
      expect(AlaveteliLocalization.available_locales).to eq([:en_GB, :es])
    end

  end

end
# Helpers for managing records with translations
module Admin::TranslatedRecordHelper
  def locale_tabs(record)
    render partial: 'admin/translated_record/locale_tabs',
           locals: { record: record }
  end
end

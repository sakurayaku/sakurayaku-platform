class Line < ApplicationRecord
  belongs_to :game_file

  has_many :translations

  def translation_fr_record
    @translation_fr_record ||= translations.find_or_create_by(game_file_id: game_file.id, locale: 'fr')
  end

  def translation_fr
    translation_fr = translation_fr_record.text
  end

  def translation_fr=(new_text)
    return true unless new_text.presence
    current_text = translation_fr_record.read_attribute('text')
    return true if new_text == current_text

    translation_fr_record.update!(text: new_text)
  end
end

class Translation < ApplicationRecord
  belongs_to :user
  belongs_to :game_file
  belongs_to :line

  def text=(new_text)
    current_text = read_attribute('text')
    return true if new_text == current_text

    history["#{Time.now.to_i.to_s}:#{user_id}"] = current_text
    history_will_change!
    super(new_text)
  end
end

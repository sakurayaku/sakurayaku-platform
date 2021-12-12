class GameFile < ApplicationRecord
  has_many :lines
  has_many :translations

  class << self
    def sak_tai1; where(game: 'SakTai1'); end
    def sak_tai2; where(game: 'SakTai2'); end
    def sak_tai3; where(game: 'SakTai3'); end

    def game_collection
      [['Sakura Taisen', 'SakTai1']]
    end
  end

  class << self
    def joins_lines
      joins(%[
        LEFT JOIN (
          SELECT
            game_file_id,
            COALESCE(COUNT(*), 0) AS count_lines
          FROM lines
          GROUP BY game_file_id
        ) lines_count
        ON lines_count.game_file_id = game_files.id
      ])
    end

    def joins_translation(locale)
      joins(%[
        LEFT JOIN (
          SELECT
            game_file_id,
            COALESCE(COUNT(*), 0) AS count_#{locale}
          FROM translations
          WHERE locale = '#{locale}'
          GROUP BY game_file_id
        ) translations_#{locale}
        ON translations_#{locale}.game_file_id = game_files.id
      ])
    end
  end
end

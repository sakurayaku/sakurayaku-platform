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
end

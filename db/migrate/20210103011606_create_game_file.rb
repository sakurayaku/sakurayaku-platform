class CreateGameFile < ActiveRecord::Migration[6.1]
  def change
    create_table :game_files do |t|
      t.string :game, null: false, default: 'SakTai1' # :-)
      t.string :name, null: :false
      t.string :description
      t.integer :line_count, null: false, default: 0

      t.timestamps precision: 3
    end

    add_index :game_files, [:game, :name], unique: true
  end
end

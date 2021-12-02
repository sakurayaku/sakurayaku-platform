class CreateLine < ActiveRecord::Migration[6.1]
  def change
    create_table :lines do |t|
      t.references :game_file, null: false

      # Whatever, these will be auto-filled
      t.boolean :unused, default: false
      t.integer :row_number
      t.string :face
      t.string :speaker, default: 'Und.'
      t.string :japanese
      t.string :japanese_ocr
      t.string :english
      t.string :line_id
      t.string :order
      t.string :crc
      t.boolean :has_dupe

      t.timestamps
    end

    add_index :lines, [:game_file_id, :row_number], unique: true
  end
end

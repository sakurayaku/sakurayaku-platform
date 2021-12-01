class CreateTranslation < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')

    create_table :translations do |t|
      t.references :line, null: false
      t.references :user, null: false
      t.references :game_file, null: false

      t.string :locale, null: false, default: 'fr'
      t.string :text, null: false

      t.hstore :history, null: false, default: {}

      t.timestamps
    end
  end
end

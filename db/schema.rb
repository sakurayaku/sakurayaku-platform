# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_03_012836) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "game_files", force: :cascade do |t|
    t.string "game", default: "SakTai1", null: false
    t.string "name"
    t.string "description"
    t.integer "line_count", default: 0, null: false
    t.datetime "created_at", precision: 3, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.index ["game", "name"], name: "index_game_files_on_game_and_name", unique: true
  end

  create_table "lines", force: :cascade do |t|
    t.bigint "game_file_id", null: false
    t.boolean "unused", default: false
    t.integer "row_number"
    t.string "face"
    t.string "speaker", default: "Und."
    t.string "japanese"
    t.string "english"
    t.string "line_id"
    t.string "order"
    t.string "crc"
    t.boolean "has_dupe"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_file_id", "row_number"], name: "index_lines_on_game_file_id_and_row_number", unique: true
    t.index ["game_file_id"], name: "index_lines_on_game_file_id"
  end

  create_table "translations", force: :cascade do |t|
    t.bigint "line_id", null: false
    t.bigint "user_id", null: false
    t.bigint "game_file_id", null: false
    t.string "locale", default: "fr", null: false
    t.string "text", null: false
    t.hstore "history", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_file_id"], name: "index_translations_on_game_file_id"
    t.index ["line_id"], name: "index_translations_on_line_id"
    t.index ["user_id"], name: "index_translations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "role"
    t.string "email", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 3, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

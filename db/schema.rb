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

ActiveRecord::Schema.define(version: 2025_03_14_102246) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hair_colors", force: :cascade do |t|
    t.string "name"
    t.string "hex_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "hair_days", force: :cascade do |t|
    t.string "img_link"
    t.string "memo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "hair_histories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "salon_id", null: false
    t.bigint "hair_week_id", null: false
    t.bigint "stylist_id", null: false
    t.integer "color_type"
    t.integer "evaluation"
    t.string "memo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "start_date"
    t.date "end_date"
    t.index ["hair_week_id"], name: "index_hair_histories_on_hair_week_id"
    t.index ["salon_id"], name: "index_hair_histories_on_salon_id"
    t.index ["stylist_id"], name: "index_hair_histories_on_stylist_id"
    t.index ["user_id"], name: "index_hair_histories_on_user_id"
  end

  create_table "hair_history_bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "hair_history_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hair_history_id"], name: "index_hair_history_bookmarks_on_hair_history_id"
    t.index ["user_id"], name: "index_hair_history_bookmarks_on_user_id"
  end

  create_table "hair_history_colors", force: :cascade do |t|
    t.bigint "hair_history_id", null: false
    t.bigint "hair_color_id", null: false
    t.integer "percentage"
    t.integer "order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hair_color_id"], name: "index_hair_history_colors_on_hair_color_id"
    t.index ["hair_history_id"], name: "index_hair_history_colors_on_hair_history_id"
  end

  create_table "hair_history_likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "hair_history_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hair_history_id"], name: "index_hair_history_likes_on_hair_history_id"
    t.index ["user_id"], name: "index_hair_history_likes_on_user_id"
  end

  create_table "hair_weeks", force: :cascade do |t|
    t.bigint "day1_hair_id", null: false
    t.bigint "day2_hair_id"
    t.bigint "day3_hair_id"
    t.bigint "day4_hair_id"
    t.bigint "day5_hair_id"
    t.bigint "day6_hair_id"
    t.bigint "day7_hair_id"
    t.bigint "day8_hair_id"
    t.bigint "day9_hair_id"
    t.bigint "day10_hair_id"
    t.bigint "day11_hair_id"
    t.bigint "day12_hair_id"
    t.bigint "day13_hair_id"
    t.bigint "day14_hair_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["day10_hair_id"], name: "index_hair_weeks_on_day10_hair_id"
    t.index ["day11_hair_id"], name: "index_hair_weeks_on_day11_hair_id"
    t.index ["day12_hair_id"], name: "index_hair_weeks_on_day12_hair_id"
    t.index ["day13_hair_id"], name: "index_hair_weeks_on_day13_hair_id"
    t.index ["day14_hair_id"], name: "index_hair_weeks_on_day14_hair_id"
    t.index ["day1_hair_id"], name: "index_hair_weeks_on_day1_hair_id"
    t.index ["day2_hair_id"], name: "index_hair_weeks_on_day2_hair_id"
    t.index ["day3_hair_id"], name: "index_hair_weeks_on_day3_hair_id"
    t.index ["day4_hair_id"], name: "index_hair_weeks_on_day4_hair_id"
    t.index ["day5_hair_id"], name: "index_hair_weeks_on_day5_hair_id"
    t.index ["day6_hair_id"], name: "index_hair_weeks_on_day6_hair_id"
    t.index ["day7_hair_id"], name: "index_hair_weeks_on_day7_hair_id"
    t.index ["day8_hair_id"], name: "index_hair_weeks_on_day8_hair_id"
    t.index ["day9_hair_id"], name: "index_hair_weeks_on_day9_hair_id"
  end

  create_table "salon_staffs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "salon_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["salon_id"], name: "index_salon_staffs_on_salon_id"
    t.index ["user_id"], name: "index_salon_staffs_on_user_id"
  end

  create_table "salons", force: :cascade do |t|
    t.string "place_id"
    t.string "name"
    t.string "address"
    t.string "phone_number"
    t.string "website"
    t.float "latitude"
    t.float "longitude"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_follows", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "followed_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followed_id"], name: "index_user_follows_on_followed_id"
    t.index ["follower_id"], name: "index_user_follows_on_follower_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "profile_img_link"
    t.integer "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "hair_histories", "hair_weeks"
  add_foreign_key "hair_histories", "salons"
  add_foreign_key "hair_histories", "users"
  add_foreign_key "hair_histories", "users", column: "stylist_id"
  add_foreign_key "hair_history_bookmarks", "hair_histories"
  add_foreign_key "hair_history_bookmarks", "users"
  add_foreign_key "hair_history_colors", "hair_colors"
  add_foreign_key "hair_history_colors", "hair_histories"
  add_foreign_key "hair_history_likes", "hair_histories"
  add_foreign_key "hair_history_likes", "users"
  add_foreign_key "hair_weeks", "hair_days", column: "day10_hair_id"
  add_foreign_key "hair_weeks", "hair_days", column: "day11_hair_id"
  add_foreign_key "hair_weeks", "hair_days", column: "day12_hair_id"
  add_foreign_key "hair_weeks", "hair_days", column: "day13_hair_id"
  add_foreign_key "hair_weeks", "hair_days", column: "day14_hair_id"
  add_foreign_key "hair_weeks", "hair_days", column: "day1_hair_id"
  add_foreign_key "hair_weeks", "hair_days", column: "day2_hair_id"
  add_foreign_key "hair_weeks", "hair_days", column: "day3_hair_id"
  add_foreign_key "hair_weeks", "hair_days", column: "day4_hair_id"
  add_foreign_key "hair_weeks", "hair_days", column: "day5_hair_id"
  add_foreign_key "hair_weeks", "hair_days", column: "day6_hair_id"
  add_foreign_key "hair_weeks", "hair_days", column: "day7_hair_id"
  add_foreign_key "hair_weeks", "hair_days", column: "day8_hair_id"
  add_foreign_key "hair_weeks", "hair_days", column: "day9_hair_id"
  add_foreign_key "salon_staffs", "salons"
  add_foreign_key "salon_staffs", "users"
  add_foreign_key "user_follows", "users", column: "followed_id"
  add_foreign_key "user_follows", "users", column: "follower_id"
end

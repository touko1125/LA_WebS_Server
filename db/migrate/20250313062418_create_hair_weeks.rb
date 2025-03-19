class CreateHairWeeks < ActiveRecord::Migration[6.1]
  def change
    create_table :hair_weeks do |t|
      t.references :day1_hair_id, null: false, foreign_key: { to_table: :hair_days }
      t.references :day2_hair_id, null: true, foreign_key: { to_table: :hair_days }
      t.references :day3_hair_id, null: true, foreign_key: { to_table: :hair_days }
      t.references :day4_hair_id, null: true, foreign_key: { to_table: :hair_days }
      t.references :day5_hair_id, null: true, foreign_key: { to_table: :hair_days }
      t.references :day6_hair_id, null: true, foreign_key: { to_table: :hair_days }
      t.references :day7_hair_id, null: true, foreign_key: { to_table: :hair_days }
      t.references :day8_hair_id, null: true, foreign_key: { to_table: :hair_days }
      t.references :day9_hair_id, null: true, foreign_key: { to_table: :hair_days }
      t.references :day10_hair_id, null: true, foreign_key: { to_table: :hair_days }
      t.references :day11_hair_id, null: true, foreign_key: { to_table: :hair_days }
      t.references :day12_hair_id, null: true, foreign_key: { to_table: :hair_days }
      t.references :day13_hair_id, null: true, foreign_key: { to_table: :hair_days }
      t.references :day14_hair_id, null: true, foreign_key: { to_table: :hair_days }

      t.timestamps
    end
  end
end
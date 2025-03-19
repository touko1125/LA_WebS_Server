class RenameHairWeek < ActiveRecord::Migration[6.1]
  def change
    rename_column :hair_weeks, :day1_hair_id_id, :day1_hair_id
    rename_column :hair_weeks, :day2_hair_id_id, :day2_hair_id
    rename_column :hair_weeks, :day3_hair_id_id, :day3_hair_id
    rename_column :hair_weeks, :day4_hair_id_id, :day4_hair_id
    rename_column :hair_weeks, :day5_hair_id_id, :day5_hair_id
    rename_column :hair_weeks, :day6_hair_id_id, :day6_hair_id
    rename_column :hair_weeks, :day7_hair_id_id, :day7_hair_id
    rename_column :hair_weeks, :day8_hair_id_id, :day8_hair_id
    rename_column :hair_weeks, :day9_hair_id_id, :day9_hair_id
    rename_column :hair_weeks, :day10_hair_id_id, :day10_hair_id
    rename_column :hair_weeks, :day11_hair_id_id, :day11_hair_id
    rename_column :hair_weeks, :day12_hair_id_id, :day12_hair_id
    rename_column :hair_weeks, :day13_hair_id_id, :day13_hair_id
    rename_column :hair_weeks, :day14_hair_id_id, :day14_hair_id
  end
end

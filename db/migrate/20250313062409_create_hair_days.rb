class CreateHairDays < ActiveRecord::Migration[6.1]
  def change
    create_table :hair_days do |t|
      t.string :img_link
      t.string :memo

      t.timestamps
    end
  end
end
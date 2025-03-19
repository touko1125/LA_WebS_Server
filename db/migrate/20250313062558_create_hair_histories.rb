class CreateHairHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :hair_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :salon, null: false, foreign_key: true
      t.references :hair_week, null: false, foreign_key: true
      t.references :stylist, null: false, foreign_key: { to_table: :users }
      t.integer :color_type
      t.integer :evaluation
      t.string :memo

      t.timestamps
    end
  end
end
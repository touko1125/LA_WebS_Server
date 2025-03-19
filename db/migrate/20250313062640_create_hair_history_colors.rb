class CreateHairHistoryColors < ActiveRecord::Migration[6.1]
  def change
    create_table :hair_history_colors do |t|
      t.references :hair_history, null: false, foreign_key: true
      t.references :hair_color, null: false, foreign_key: true
      t.integer :percentage
      t.integer :order

      t.timestamps
    end
  end
end
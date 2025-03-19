class CreateHairColors < ActiveRecord::Migration[6.1]
  def change
    create_table :hair_colors do |t|
      t.string :name
      t.string :hex_code

      t.timestamps
    end
  end
end
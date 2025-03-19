class CreateSalons < ActiveRecord::Migration[6.1]
  def change
    create_table :salons do |t|
      t.integer :place_id
      t.string :name
      t.string :address
      t.string :phone_number
      t.string :website
      t.float :latitude
      t.float :longitude
      t.integer :status

      t.timestamps
    end
  end
end
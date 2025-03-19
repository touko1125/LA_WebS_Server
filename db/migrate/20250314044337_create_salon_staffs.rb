class CreateSalonStaffs < ActiveRecord::Migration[6.1]
  def change
    create_table :salon_staffs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :salon, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class AddColumnStartdateHairHistory < ActiveRecord::Migration[6.1]
  def change
    add_column :hair_histories, :start_date, :date
    add_column :hair_histories, :end_date, :date
  end
end

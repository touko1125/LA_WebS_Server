class ChangeColumnSalonId < ActiveRecord::Migration[6.1]
  def change
    change_column :salons, :place_id, :string
  end
end

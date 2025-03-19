class CreateHairHistoryBookmarks < ActiveRecord::Migration[6.1]
  def change
    create_table :hair_history_bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :hair_history, null: false, foreign_key: true

      t.timestamps
    end
  end
end

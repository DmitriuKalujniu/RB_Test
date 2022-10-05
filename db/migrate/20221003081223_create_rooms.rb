class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :link
      t.references :user
      t.timestamps
    end
  end
end

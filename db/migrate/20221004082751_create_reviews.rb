class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.bigint :original_id
      t.integer :area
      t.integer :rating
      t.text :comment
      t.datetime :created
      t.string :reviewer_name
      t.string :user_picture
      t.references :room
      t.timestamps
    end
  end
end

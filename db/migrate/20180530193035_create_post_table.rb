class CreatePostTable < ActiveRecord::Migration[5.2]
  def change
      create_table :posts do |t|
        t.integer :user_id
        t.string :title
        t.string :post
        t.datetime :created_at
        t.datetime :updated_at
      end
  end
end

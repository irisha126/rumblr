class CreateUserTable < ActiveRecord::Migration[5.2]
  def change
      create_table :users do |t|
          t.string :first_name
          t.string :last_name
          t.date :birthday
          t.string :email
          t.string :password
          t.string :username
          t.datetime :created_at
      end   
  end
end

class AddSessionsTable < ActiveRecord::Migration
  def change
    remove_column :users, :session_token
    create_table :sessions do |t|
      t.integer :user_id, null: false
      t.text :session_token, null: false
      t.text :user_agent, null: false
      t.string :ip_address, null: false
      t.timestamps null: false
    end
    add_index :sessions, :user_id
    add_index :sessions, :session_token, unique: true
  end
end

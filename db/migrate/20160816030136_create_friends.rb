class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
    	t.integer :user_id
    	t.integer :user_friend_id
    	t.integer :is_accept, :default => 0
    	t.integer :is_invite, :default => 0
    	t.integer :is_favorite, :deafult => 0
      t.timestamps null: false
    end
  end
end

class AddFieldAcceptIdToFriendsTable < ActiveRecord::Migration
  def change
	add_column :friends, :accept_id, :integer
  end
end

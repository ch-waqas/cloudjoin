class RemoveDropboxSessionFromUsers < ActiveRecord::Migration
  def up
  	remove_column :users, :dropbox_session
  end

  def down
  	add_column :users, :dropbox_session
  end
end

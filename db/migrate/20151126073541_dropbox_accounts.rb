class DropboxAccounts < ActiveRecord::Migration
  def up
  	 create_table(:dropbox_accounts) do |t|
  	 	t.string :dropbox_session
  	 	t.integer :user_id
  	 end
  end

  def down
  end
end

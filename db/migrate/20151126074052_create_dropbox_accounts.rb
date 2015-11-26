class CreateDropboxAccounts < ActiveRecord::Migration
  def change
    create_table :dropbox_accounts do |t|
      t.string :session
      t.references :user

      t.timestamps
    end
    add_index :dropbox_accounts, :user_id
  end
end

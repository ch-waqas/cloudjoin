class CreateGoogleAccounts < ActiveRecord::Migration
  def change
    create_table :google_accounts do |t|
      t.text :session
      t.references :user

      t.timestamps
    end
    add_index :google_accounts, :user_id
  end
end

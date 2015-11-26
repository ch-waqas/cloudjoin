class DropboxAccount < ActiveRecord::Base
  belongs_to :user
  attr_accessible :session
end

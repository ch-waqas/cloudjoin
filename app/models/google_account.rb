class GoogleAccount < ActiveRecord::Base
  belongs_to :user
  attr_accessible :session
end

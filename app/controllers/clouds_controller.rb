
class CloudsController < ApplicationController
  def show
  end

  def index
    @clients = []
     if current_user.dropbox_accounts.present?            
        current_user.dropbox_accounts.each do |account|
           dbsession = DropboxSession.deserialize(account.session)
           # create the dropbox client object

           @clients << DropboxClient.new(dbsession, :dropbox).metadata('/')
      end
    end

  end

  def edit
  end

  def create
  end

  def update
  end

  def validate
    
  end

  def new
      
  end
end

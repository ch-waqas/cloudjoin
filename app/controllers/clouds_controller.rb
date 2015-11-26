
class CloudsController < ApplicationController
  def show
  end

  def index
     if current_user.dropbox_session
       dbsession = DropboxSession.deserialize(current_user.dropbox_session)
       # create the dropbox client object
       @client = DropboxClient.new(dbsession, :dropbox).metadata('/')

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


class CloudsController < ApplicationController
  def show
  end

  def index
    @clients = []

    @accounts  = current_user.dropbox_accounts.order('id asc')
     if @accounts.present?
        @accounts.each do |account|
           dbsession = DropboxSession.deserialize(account.session)
           # create the dropbox client object

           @clients << DropboxClient.new(dbsession, :dropbox)
        end

       @files = []
       @clients.each do |client|
         files = get_dir_meta('/',client)
        @files << files.flatten
       end

       puts "************** fiels #{@files.inspect}"
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

 private
  def get_dir_meta(dir,client)
    files = []
    meta_data = client.metadata(dir)
    meta_data["contents"].each do |c|
      if c['is_dir']
        files << get_dir_meta(c['path'], client)
      else
        c['name'] = dir == '/' ? c['path'][1..-1] : c['path'][dir.length+1..-1]
        files << c
      end
    end
    files
  end


end

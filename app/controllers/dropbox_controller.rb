require 'dropbox_sdk'

class DropboxController < ApplicationController

	def authorize
		puts "heree ************ "
		dbsession = DropboxSession.new(DROPBOX_APP_KEY, DROPBOX_APP_KEY_SECRET)
		#serialize and save this DropboxSession
		session[:dropbox_session] = dbsession.serialize
		#pass to get_authorize_url a callback url that will return the user here
		puts "heree ************ "
		redirect_to dbsession.get_authorize_url url_for(:action => 'dropbox_callback')
	end
	 
	# @Params : None
	# # @Return : None
	# # @Purpose : To callback for dropbox authorization
	def dropbox_callback
		# ActionController::Parameters.permit_all_parameters = true

		dbsession = DropboxSession.deserialize(session[:dropbox_session])
		dbsession.get_access_token #we've been authorized, so now request an access_token
		session[:dropbox_session] = dbsession.serialize
		current_user.set_session_value( session[:dropbox_session])
		# current_user.update_attributes(:dropbox_session => session[:dropbox_session])
		session.delete :dropbox_session
		flash[:success] = "You have successfully authorized with dropbox."
		redirect_to clouds_path 
	end # end of dropbox_callback action


	def dropbox_upload
		id = params[:account_id]
		account = current_user.dropbox_accounts.find(id)
		dbsession = DropboxSession.deserialize(account.session)
		uploaded_io = params[:upload_file]

		client = DropboxClient.new(dbsession, DROPBOX_APP_MODE)
		File.open(Rails.root.join('public', uploaded_io.original_filename), 'wb') do |file|
			file.write(uploaded_io.read)
		end

		file = File.open(Rails.root.join('public', uploaded_io.original_filename), "r")
		client.put_file( uploaded_io.original_filename, file)

		flash[:success] =  'Yahooo'
		redirect_to clouds_path
	end

	def dropbox_download
		puts '11211212-----'
		id = params[:account_id]
		account = current_user.dropbox_accounts.find(id)
		dbsession = DropboxSession.deserialize(account.session)
		# dbsession = current_user.dropbox_accounts.first.session

		require 'open-uri'

		file_name = params[:name]
		open(file_name, 'wb') do |file|
			file << DropboxClient.new(dbsession, DROPBOX_APP_MODE).get_file(params[:path], rev=nil)
		end

		# file =  DropboxClient.new(dbsession, DROPBOX_APP_MODE).get_file(params[:path], rev=nil)
		# puts "*** fiel #{file.inspect} params path #{params[:path]}"
		send_file file_name
	end

	# def unauthorize
	# 	session[:dropbox_session] = nil
	# 	current_user.dropbox_session = nil
	# 	current_user.save!
	# end
end

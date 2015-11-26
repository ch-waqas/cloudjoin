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

	# def unauthorize
	# 	session[:dropbox_session] = nil
	# 	current_user.dropbox_session = nil
	# 	current_user.save!
	# end
end

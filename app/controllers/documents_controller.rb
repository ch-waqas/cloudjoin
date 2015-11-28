require 'google_drive'
require 'google_docs'
class DocumentsController < ApplicationController
  before_filter :google_drive_login, :only => [:list_google_docs]

  GOOGLE_CLIENT_ID = "220658305464-4du2fg2t3q1b75gtnvaluij5ui9vm1u7.apps.googleusercontent.com"
  GOOGLE_CLIENT_SECRET = "Kn-VOsGkgLTKFf-iLTVZ87AP"
  GOOGLE_CLIENT_REDIRECT_URI = "http://localhost:3000/oauth2callback"
  # you better put constant like above in environments file, I have put it just for simplicity
  def list_google_docs

    google_session = GoogleDrive.login_with_oauth(current_user.google_accounts.first.session)
    # google_session = GoogleDrive.saved_session(current_user.google_accounts.first.session, nil, CLIENT_ID, CLIENT_SECRET)
    @google_docs = []
    for file in google_session.files
      @google_docs  << file.title
    end
  end

  # def download_google_docs
  #   file_name = params[:doc_upload]
  #   file_path = Rails.root.join('tmp',"doc_#{file_name_session = GoogleDrive.login_with_oauth(session[:google_token])
  #                                    file = google_session.file_by_title(file_name)
  #                                    file.download_to_file(file_path)
  #                                    redirect_to list_google_doc_path
  # end

   def set_google_drive_token

     google_doc = GoogleDrive::GoogleDocs.new(GOOGLE_CLIENT_ID,GOOGLE_CLIENT_SECRET,
                                              GOOGLE_CLIENT_REDIRECT_URI)
     oauth_client = google_doc.create_google_client
     auth_token = oauth_client.auth_code.get_token(params[:code],
                                                   :redirect_uri => GOOGLE_CLIENT_REDIRECT_URI)

     current_user.google_accounts << GoogleAccount.new(session: params[:code]) if oauth_token

     redirect_to list_google_doc_path
   end

   def google_drive_login
     # session[:google_token] = nil
       google_drive = GoogleDrive::GoogleDocs.new(GOOGLE_CLIENT_ID,GOOGLE_CLIENT_SECRET,
                                                  GOOGLE_CLIENT_REDIRECT_URI)
       auth_url = google_drive.set_google_authorize_url
       redirect_to auth_url
   end
end
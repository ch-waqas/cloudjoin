require 'google_drive'
require 'google_docs'
class DocumentsController < ApplicationController

  GOOGLE_CLIENT_ID = "220658305464-4du2fg2t3q1b75gtnvaluij5ui9vm1u7.apps.googleusercontent.com"
  GOOGLE_CLIENT_SECRET = "Kn-VOsGkgLTKFf-iLTVZ87AP"
  GOOGLE_CLIENT_REDIRECT_URI = "http://localhost:3000/oauth2callback"

  def list_google_docs

    @accounts = current_user.google_accounts

    @files = []
    @accounts.each do |account|
      google_session = get_google_session(account.session)
      files = []
      for file in google_session.files
        files  << file.title
      end

      @files << files
    end
  end

            def destroy
            @acc  = current_user.google_accounts.find(params[:id])
            @acc.destroy

           redirect_to :back
          end


  def get_google_session(refresh)
    client = Google::APIClient.new
    auth = client.authorization

    auth.client_id = GOOGLE_CLIENT_ID
    auth.client_secret = GOOGLE_CLIENT_SECRET
    auth.scope ='https://www.googleapis.com/auth/drive'
    auth.grant_type = 'refresh_token'

    auth.redirect_uri = GOOGLE_CLIENT_REDIRECT_URI

    auth.refresh_token = refresh
    grant = auth.refresh!
    google_session = GoogleDrive.login_with_oauth(grant['access_token'])
    google_session
  end

  def download_google_docs
    file_name = params[:doc_upload]
    account_id= params[:account_id]
    # return render :json=> params.inspect
    token = current_user.google_accounts.find_by_id(account_id.to_i).session

    google_session = get_google_session(token)

    file = google_session.file_by_title(file_name)

    file_path = Rails.root.join('public',"#{file_name}")
   file.download_to_file(file_path)
    send_file File.open(file_path)
   # redirect_to list_google_doc_path
  end

   def set_google_drive_token
     auth_token = exchange_code(params[:code])
     current_user.google_accounts << GoogleAccount.new(session: auth_token.refresh_token) if auth_token

     redirect_to list_google_doc_path
   end

   def google_drive_login
       google_drive = GoogleDrive::GoogleDocs.new(GOOGLE_CLIENT_ID,GOOGLE_CLIENT_SECRET,
                                                  GOOGLE_CLIENT_REDIRECT_URI)
       auth_url = google_drive.set_google_authorize_url
       redirect_to auth_url
   end

  def exchange_code(authorization_code)
    client = Google::APIClient.new
    client.authorization.client_id = GOOGLE_CLIENT_ID
    client.authorization.client_secret = GOOGLE_CLIENT_SECRET
    client.authorization.code = authorization_code
    client.authorization.redirect_uri = GOOGLE_CLIENT_REDIRECT_URI

    client.authorization.fetch_access_token!
    client.authorization
  end

end
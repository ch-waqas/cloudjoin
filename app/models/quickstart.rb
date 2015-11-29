require "google/api_client"
require "google_drive"

# The client ID and client secret you obtained in the step above.
CLIENT_ID = "220658305464-4du2fg2t3q1b75gtnvaluij5ui9vm1u7.apps.googleusercontent.com"
CLIENT_SECRET = "Kn-VOsGkgLTKFf-iLTVZ87AP"

# Creates a session. This will prompt the credential via command line for the
# first time and save it to ./stored_token.json file for later usages.
#
# If you are developing a Web app, and you want to ask the user to log in in
# the Web app instead of via command line, follow the example code in:
# http://gimite.net/doc/google-drive-ruby/GoogleDrive.html#method-c-login_with_oauth
    session = GoogleDrive.saved_session("./stored_token.json", nil, CLIENT_ID, CLIENT_SECRET)

# Gets list of remote files.
session.files.each do |file|
  p file.title
end

# Uploads a local file.
session.upload_from_file("/path/to/hello.txt", "hello.txt", convert: false)

# Downloads to a local file.
file = session.file_by_title("hello.txt")
file.download_to_file("/path/to/hello.txt")

# Updates content of the remote file.
file.update_from_file("/path/to/hello.txt")
# require 'google/api_client'
# require 'google/api_client/client_secrets'
# require 'google/api_client/auth/installed_app'
# require 'google/api_client/auth/storage'
# require 'google/api_client/auth/storages/file_store'
# require 'fileutils'
#
# APPLICATION_NAME = 'Drive API Ruby Quickstart'
# CLIENT_SECRETS_PATH = 'client_secret.json'
# CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
#                              "drive-ruby-quickstart.json")
# SCOPE = 'https://www.googleapis.com/auth/drive.metadata.readonly'
#
# ##
# # Ensure valid credentials, either by restoring from the saved credentials
# # files or intitiating an OAuth2 authorization request via InstalledAppFlow.
# # If authorization is required, the user's default browser will be launched
# # to approve the request.
# #
# # @return [Signet::OAuth2::Client] OAuth2 credentials
# def authorize
#   FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))
#
#   file_store = Google::APIClient::`FileStore`.new(CREDENTIALS_PATH)
#   storage = Google::APIClient::Storage.new(file_store)
#   auth = storage.authorize
#
#   if auth.nil? || (auth.expired? && auth.refresh_token.nil?)
#     app_info = Google::APIClient::ClientSecrets.load(CLIENT_SECRETS_PATH)
#     flow = Google::APIClient::InstalledAppFlow.new({
#                                                        :client_id => app_info.client_id,
#                                                        :client_secret => app_info.client_secret,
#                                                        :scope => SCOPE})
#     auth = flow.authorize(storage)
#     puts "Credentials saved to #{CREDENTIALS_PATH}" unless auth.nil?
#   end
#   auth
# end
#
# # Initialize the API
# client = Google::APIClient.new(:application_name => APPLICATION_NAME)
# client.authorization = authorize
# drive_api = client.discovered_api('drive', 'v2')
#
# # List the 10 most recently modified files.
# results = client.execute!(
#     :api_method => drive_api.files.list,
#     :parameters => { :maxResults => 10 })
# puts "Files:"
# puts "No files found" if results.data.items.empty?
# results.data.items.each do |file|
#   puts "#{file.title} (#{file.id})"
# end
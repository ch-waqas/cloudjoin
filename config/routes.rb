Clouder::Application.routes.draw do
  get 'dropbox/authorize' => 'dropbox#authorize', as: 'dropbox_authorize'
  # get '/dropbox_unauthorize' => 'dropbox#unauthorize', as: 'dropbox_unauthorize'
  # get '/dropbox_path_change' => '#dropbox_path_change', as: 'dropbox_path_change'
  get 'dropbox/callback' => 'dropbox#dropbox_callback', as: 'dropbox_callback'
  get '/dropbox_download' => 'dropbox#dropbox_download', as: 'dropbox_download'
  post '/dropbox_upload' => 'dropbox#dropbox_upload', as: 'dropbox_upload'
  # post '/dropbox_upload' => 'dropbox#upload', as: 'upload'
  # post '/dropbox_search' => 'dropbox#search', as: 'search'
  match '/oauth2callback' => 'documents#set_google_drive_token'
  match '/google'  => 'documents#list_google_docs', :as => :list_google_doc #for listing the
  #google docs
  match '/download_google_doc'  => 'documents#download_google_docs', :as => :download_google_doc #download
  match '/google_drive_login'  => 'documents#google_drive_login', :as => :google_drive_login #download

  devise_for :users, path: '', path_names: {sign_up: "signup", sign_in: "login", sign_out: "logout"}

delete 'documents' => 'documents#destroy'
delete 'documentsdropbox' => 'dropbox#destroy'


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  root :to => 'home#index'
  resources :clouds do
    collection do
      # get 'new'
      # get 'validate'
    end
  end


  resources :home, path: '' do
    collection do
      get 'about'
      get 'faq'
      get 'howto'
      get 'contactus'
    end
  end

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

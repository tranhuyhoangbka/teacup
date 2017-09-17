require 'sidekiq/web'

Rails.application.routes.draw do
  #mount ActionCable.server => '/cable'
  resources :messages
  
  devise_for :users, skip: [:sessions]  
  
  devise_scope :user do
    get "login" => "sessions#new", as: :user_session
    get "logout" => "devise/sessions#destroy",  as: :user_logout
    post "login" => "sessions#create", as: :user_login
  end


  authenticate :admin do
    mount Sidekiq::Web => '/admin/sidekiq'
  end  
  devise_for :admins, skip: [:sessions]
  
  get "/admin/" => "admin/top_page#show", as: :admin_root
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/home' => "pages#home"
  root to: "pages#home"
  
  devise_scope :admin do
    get "/admin/login" => "admin/sessions#new", as: :admin_session
    post "/admin/login" => "admin/sessions#create", as: :admin_login
    get "/admin/logout" => "admin/sessions#destroy",  as: :admin_logout
  end

  namespace :admin do
    resources :posts
    resources :users
  end

end

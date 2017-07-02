require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  authenticate :admin do
    mount Sidekiq::Web => '/admin/sidekiq'
  end
  scope defaults: (Rails.env.production? ? { protocol: 'https' } : {}) do
    devise_for :admins, skip: [:sessions]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/home' => "pages#home"
  root to: "pages#home"

  scope defaults: (Rails.env.production? ? { protocol: 'https' } : {}) do
    devise_scope :admin do
      get "/admin/login" => "admin/sessions#new", as: :admin_session
      post "/admin/login" => "admin/sessions#create", as: :admin_login
      get "/admin/logout" => "admin/sessions#destroy",  as: :admin_logout
    end
  end
  namespace :admin do
    resources :posts
    resources :users
  end

  # authenticate :admin do
  #   namespace :admin do
  #     resources :posts
  #   end
  # end

  scope :admin, as: :admin do
    authenticated do
      scope defaults: (Rails.env.production? ? { protocol: 'https' } : {}) do
        root to: "admin/top_page#show", as: :root
      end
    end

    unauthenticated do
      devise_scope :admin do
        scope defaults: (Rails.env.production? ? { protocol: 'https' } : {}) do
          root to: "admin/sessions#new", as: :unauthenticated
        end
      end
    end
  end
end

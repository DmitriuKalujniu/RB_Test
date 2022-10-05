Rails.application.routes.draw do
  devise_for :users
  get 'persons/profile', as: 'user_root'
    resources :rooms
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "rooms#index"
end

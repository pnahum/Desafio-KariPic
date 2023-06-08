Rails.application.routes.draw do
  resources :photos
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post "photos/:id" => "photos#update", :as => :create_comment
  # Defines the root path route ("/")
  root "photos#index"
end

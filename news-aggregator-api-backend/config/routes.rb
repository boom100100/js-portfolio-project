Rails.application.routes.draw do
  resources :links
  resources :topics
  resources :users
  #  resources :articles, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

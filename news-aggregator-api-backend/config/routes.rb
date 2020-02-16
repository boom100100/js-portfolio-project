Rails.application.routes.draw do
  #resources :links
  #root 'application#index'
  #route 'welcome#index'
  resources :topics, only: [:index, :show]#routes not required: :new, :create, :destroy; completely unutilized: :edit, :update
  resources :links, only: [:index, :show]#routes not required: :new, :create, :destroy; completely unutilized: :edit, :update
  #resources :users
  #  resources :articles, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

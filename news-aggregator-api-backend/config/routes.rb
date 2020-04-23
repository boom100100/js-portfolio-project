Rails.application.routes.draw do

  get 'topics/refresh', to: 'topics#refresh'
  resources :topics, only: [:index, :show] #routes not required: :new, :create, :destroy; completely unutilized: :edit, :update
  resources :links, only: [:index, :show]#routes not required: :new, :create, :destroy; completely unutilized: :edit, :update
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

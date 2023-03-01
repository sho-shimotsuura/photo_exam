Rails.application.routes.draw do
  root 'sessions#new'
  resources :pictures do
    collection do
      post :confirm
    end
  end
  resources :users
  resources :sessions
  resources :favorites
end

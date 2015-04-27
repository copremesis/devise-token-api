DeviseTokenApi::Application.routes.draw do
  devise_for :users
  devise_scope :user do
    root to: "devise/sessions#new"
  end

  namespace :api do
    namespace :v1  do
      #test routes for josh or IOS connect
      get 'debug' =>  'debug#index'
      post 'debug' =>  'debug#index'
      put 'debug' =>  'debug#index'
      delete 'debug' =>  'debug#index'

      devise_for :users


    end
  end
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  # StaticPagesController
  get 'help', to: 'static_pages#help'
  get 'about', to: 'static_pages#about'
  get 'contact', to: 'static_pages#contact'
  # UsersController
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  # SessionsController
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :users do
    # 添加带user_id的具名路由：/users/id/following
    member do
      get :following, :followers
    end
    # 添加不带user_id的具名路由：/users/tigers
    # collection do
    #   get :tigers
    # end
  end
  resources :account_activations, only: %i[edit]
  resources :password_resets, only: %i[new create edit update]
  resources :microposts, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
end

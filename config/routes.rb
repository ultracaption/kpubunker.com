EwhaNote::Application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations', sessions: 'user_sessions' }

  resources :lectures do
    get :search, on: :collection
    resources :assessments
  end

  resources :assessments do
    get :my, on: :collection
  end

  root :to => 'assessments#index'
end

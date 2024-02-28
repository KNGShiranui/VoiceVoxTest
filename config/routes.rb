Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :users, only: [:index, :show]
  resources :blogs do
    get 'my_index', on: :collection, as: :my
  end
    root 'home#home'
end

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :users, only: [:index, :show]
  resources :blogs do
    get 'my_index', on: :collection, as: :my
    get 'read_blog', on: :member, as: :read
  end
    root 'home#home'
    get 'audios/stream/:id', to: 'audios#stream', as: 'audio_stream'
end

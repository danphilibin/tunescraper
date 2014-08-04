Rails.application.routes.draw do

  root 'pages#index'

  get 'vault' => 'pages#vault', as: :vault

  resources :track

end

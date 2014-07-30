Rails.application.routes.draw do

  root 'pages#index'

  post 'scrape' => 'scraper#scrape', as: 'scrape'

end

Rails.application.routes.draw do

  root 'portfolios#index'

  resources :stocks, only: [:index, :show]
  
  resources :portfolios do
    resources :deals
  end
end

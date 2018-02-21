Rails.application.routes.draw do

  root 'portfolios#index'

  resources :stocks, only: [:index, :show]
  
  resources :portfolios do
    get 'update_profit'
    get 'profit_by_year'
    get 'profit_by_year_chart'
    resources :deals
  end
end

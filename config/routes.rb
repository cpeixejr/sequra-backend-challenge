require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  resources :disbursements
  resources :orders
  resources :merchants
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'annual_report' => 'disbursements#annual_report', as: :annual_report

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'disbursements#annual_report'

  # TODO: add authentication
  mount Sidekiq::Web => '/sidekiq'
end

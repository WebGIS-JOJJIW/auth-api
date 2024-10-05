Rails.application.routes.draw do

  match "auth/login", to: "auth#login", via: %i[options post]
  match "auth/logout", to: "auth#logout", via: %i[options post]
  match "auth/validate_token", to: "auth#validate_token", via: %i[options post]
  match "auth/renew_token", to: "auth#renew_token", via: %i[options post]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

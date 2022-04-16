Rails.application.routes.draw do
  root to: "providers#index"
  resources :providers
end

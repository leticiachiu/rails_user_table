Rails.application.routes.draw do
  get '/' => 'user#index', as: 'users'
  get '/user/:id', to: 'user#show'
end

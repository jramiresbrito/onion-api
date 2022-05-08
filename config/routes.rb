Rails.application.routes.draw do
  get '/home', to: 'home#index'

  post '/starlink/nearby', to: 'starlinks#nearby'
end

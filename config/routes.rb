Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Point the root / to the graph
  root 'points#index'

  # Allow JSON requests for the graph
  get 'points/json'

  # Allow POST requests to store data
  post 'points/create'

end

Rails.application.routes.draw do
  root 'base#api'

  namespace :api, defaults: {format: :json} do
    namespace :v1 do

      get '/info_terms', to: 'posts#info_terms'
      get '/search', to: 'posts#search'
      get '/search_neighborhoods', to: 'posts#search_neighborhoods'
      get '/sobre', to: 'posts#sobre'
      get '/slider', to: 'posts#slider'
      get '/events', to: 'posts#events'
      get '/post', to: 'posts#post'
      get '/associados', to: 'posts#associados'
      get '/gallery', to: 'posts#gallery'

      resources :posts, only: [:index] do

      end
    end
  end
end

Rails.application.routes.draw do
  get '/api' => redirect('/public/api_html/dist/index.html?url=/apidocs/api-docs.json')

  devise_for :users
  root "home#index"

  
  namespace :api, format: [:json] do
    namespace :v1 do
      resource :user, only: [:show, :update]
    end

    namespace :auth do
      devise_for :users, controllers: {sessions: 'api/auth/sessions'}, path_names: {sign_in: :login}
      post '/signup' => "authentications#signup"
      post '/signin' => "authentications#signin"
      get '/renew_token' => "authentications#renew_token"
    end
  end

end


# https://github.com/ntamvl/rails_5_api_tutorial
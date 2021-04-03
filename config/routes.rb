Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/users/:username', to: 'users#show', as: :user_path
    end
  end
end

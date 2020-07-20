Rails.application.routes.draw do
  namespace :api, format: 'json' do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: '/auth'

      resources :exports , only: [] do
        collection do
          get :tracking
        end
      end
    end
  end
end

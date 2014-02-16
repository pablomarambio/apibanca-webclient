ApibancaWebclient::Application.routes.draw do
	devise_for :users, :controllers => { 
		:omniauth_callbacks => "users/omniauth_callbacks" 
	}
	devise_scope :user do
		get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
		get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
	end
	namespace :users do
		get 'setup_form', to: "api_setup#setup_form", as: "setup"
		post 'setup_api_access', to: "api_setup#setup_api_access", as: "setup_api_access"
	end
	resources :banks do
		resources :deposits
	end

	get "/deposits", to: "deposits#router", as: "deposits"
	
	root to: "application#root"
end

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	
	def twitter
		sign_in_from :twitter
	end

	protected
	def sign_in_from provider
		h = auth_provider_hash request.env["omniauth.auth"]
		auth = AuthProvider.find_by_name_and_uid(provider, h[:uid])
		Rails.logger.debug "Auth provider found for user #{auth.user_id}" if auth
		Rails.logger.debug "No auth provider found for [#{provider}-#{h[:uid]}]" if auth.nil?

		if user_signed_in?
			# if this authentication provider is not linked to the account, add it
			if !auth
				flash[:success] = "Autentificación con provider agregada"
				current_user.add_auth_provider h
			else
				# Already added, do nothing
			end
		else
			# check if user has already signed in using this authentication provider and continue with sign in process if yes
			if auth
				flash[:success] = "Hola de nuevo, #{auth.user.name}"
				sign_in auth.user
			else
				# at this point we are facing a new user... so he must be signing up
				Rails.logger.debug "Unknown user trying to log in"
				user = nil
				User.transaction do
					user = User.new
					user.save!
					user.add_auth_provider h
					user.save!
				end
				flash[:success] = "Bienvenido(a), #{user.name}"
				sign_in user
			end
		end
		if current_user.api_key.nil?
			redirect_to users_setup_form_path
		else
			redirect_to root_path
		end
	end

	def auth_provider_hash omniauth
		hash = {}
		hash[:raw] = omniauth.to_xml
		hash[:uid] = omniauth['uid']
		hash[:uemail] = omniauth['info']['email']
		hash[:uname] = omniauth['info']['nickname'] || omniauth['info']['name']
		hash[:ap_name] = omniauth['provider']
		hash
	end
end
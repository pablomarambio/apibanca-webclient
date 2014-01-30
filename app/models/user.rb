class User < ActiveRecord::Base
	devise :omniauthable, :omniauth_providers => [:twitter, :linkedin, :google]

	has_many :auth_providers, dependent: :destroy

	def add_auth_provider(h)
		raise "Invalid auth hash" unless h
		# if the user already has this provider linked
		existing_provider = self.auth_providers.where( 'name = ?', h[:ap_name] ).first
		existing_provider.destroy if existing_provider
		self.auth_providers.create(
			:name => h[:ap_name],
			:uid => h[:uid], 
			:uname => h[:uname])
		if self.auth_providers.count == 1
			# If this is this user's only auth provider, we set his username and avatar
			self.email = h[:uemail]
			self.name = h[:uname]
		end
	end
end
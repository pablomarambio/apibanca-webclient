class WebclientController < ApplicationController
	before_filter :authenticate_user!
	before_filter :load_client

	def load_client
		@client = Apibanca::Client.new(current_user.api_key, current_user.api_uri)
	end
end
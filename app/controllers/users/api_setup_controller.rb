class Users::ApiSetupController < ApplicationController
	before_filter :authenticate_user!

	def setup_api_access
		params.require(:api_key)
	end
end
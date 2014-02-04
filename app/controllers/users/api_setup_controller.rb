class Users::ApiSetupController < ApplicationController
	before_filter :pretty_errors
	before_filter :authenticate_user!

	def setup_api_access
		api_key = params.require(:api_key)
		api_uri = params.require(:uri)
		current_user.api_key = api_key
		current_user.api_uri = api_uri
		current_user.save!
		redirect_to banks_path
	rescue ActionController::ParameterMissing
		@errors[$!.param.to_sym] = "Se requiere que llenes #{$!.param}"
		render :setup_form
	rescue ActiveRecord::ActiveRecordError
		@errors[:general] = "Error al guardar, intente de nuevo"
		render :setup_form
	end

	def setup_form
		params[:uri] = current_user.api_uri || "http://api-banca.herokuapp.com/api/2013-11-4/"
		params[:api_key] = current_user.api_key
	end

	def pretty_errors
		@errors = {}
	end
end
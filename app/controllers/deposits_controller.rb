require "rut"
class DepositsController < WebclientController
	def index
		search_params = params[:page] || {}
		unless params[:has_history].blank?
			search_params.merge(has_history: true)
		end
		unless params[:psd_type].blank?
			search_params.merge(psd_type: params[:psd_type])
		end
		unless params[:psd_origin_bank].blank?
			search_params.merge(psd_origin_bank: params[:psd_origin_bank])
		end
		unless params[:psd_origin_user_rut].blank?
			search_params.merge(psd_origin_user_rut: params[:psd_origin_user_rut])
		end
		@bank = Apibanca::Bank.load @client, params[:bank_id]
		@deposits = @bank.search_deposits(search_params)
	end
end

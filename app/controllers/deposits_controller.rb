require "rut"
class DepositsController < WebclientController
	def index
		search_params = {}
		unless params[:page].blank?
			search_params.merge!(page: params[:page])
		end
		unless params[:has_history].blank?
			search_params.merge!(has_history: true)
		end
		unless params[:psd_type].blank?
			search_params.merge!(psd_type: params[:psd_type])
		end
		unless params[:psd_origin_bank].blank?
			search_params.merge!(psd_origin_bank: params[:psd_origin_bank])
		end
		unless params[:psd_origin_user_rut].blank?
			search_params.merge!(psd_origin_user_rut: params[:psd_origin_user_rut])
		end
		@bank = Apibanca::Bank.load @client, params[:bank_id], false
		@deposits = @bank.search_deposits(search_params)
		@deposit_types = [nil, Apibanca::Deposit::TYPES].flatten
		@bank_types = [nil, Apibanca::Bank::TYPES].flatten
	end

	def show
		@bank = Apibanca::Bank.load @client, params[:bank_id], false
		@deposit = @bank.get_deposit params[:id]
	end

	def router
		@banks = Apibanca::Bank.index @client
		if @banks.empty?
			flash[:info] = "Debe inscribir una cuenta primero"
			redirect_to new_bank_path and return
		elsif @banks.length == 1
			redirect_to bank_deposits_path(bank_id: @banks.first.id) and return
		end
	end
end

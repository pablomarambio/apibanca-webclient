class BanksController < WebclientController
	def index
		@banks = Apibanca::Bank.index @client
	end

	def show
		@bank = Apibanca::Bank.load @client, params[:id]
	end
end

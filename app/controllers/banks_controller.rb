class BanksController < WebclientController
	def index
		@banks = Apibanca::Bank.index @client
	end
end

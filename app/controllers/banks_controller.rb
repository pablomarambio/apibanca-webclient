class BanksController < WebclientController
	before_filter :load_bank_names, only: [:new, :create]
	def index
		@banks = Apibanca::Bank.index @client, false
	end

	def new
		@bank = Mockups::Bank.new
		@available_bank_names = Apibanca::Bank.available @client
	end

	def create
		@bank = Mockups::Bank.new(bank_params)
		@nb = @bank.create_bank! @client
		flash[:notice] = "Banco creado!"
		redirect_to bank_path(@nb.id)
	rescue Apibanca::Client::InvalidOperationError, ActiveModel::StrictValidationFailed
		flash[:error] = $!.message
		render "new"
	end

	def show
		@bank = Apibanca::Bank.load @client, params[:id], false
	end

	def destroy
		@bank = Apibanca::Bank.load @client, params[:id], false
		@bank.delete
		flash[:info] = "Banco eliminado."
		redirect_to action: :index
	end

	private
	def load_bank_names
		@available_bank_names = Apibanca::Bank.available @client
	end

	def bank_params
		params.require(:bank).permit(:name, :user, :account, :pass)
	end
end

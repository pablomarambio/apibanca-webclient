module Mockups
	class Bank < Base

		attr_accessor :name, :user, :account, :pass

		validates :name, inclusion: { in: %w(SCOTIA BICE), message: "%{value} es desconocido" }
		validates :user, presence: true
		validates :account, presence: true
		validates :pass, presence: true

		def create_bank! client
			raise ActiveModel::StrictValidationFailed, "Corrige los errores antes de continuar" unless valid?
			Apibanca::Bank.create client, to_params
		rescue Apibanca::Client::InvalidOperationError
			copy_remote_errors $!.remote_errors
			raise
		end

		protected
		def to_params
			Apibanca::Bank::BankCreationParams.new({
				name: name,
				user: user,
				account: account,
				pass: pass
			})
		end
	end
end
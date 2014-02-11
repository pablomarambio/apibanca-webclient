module Mockups
	class Bank
		include ActiveModel::Validations
		include ActiveModel::Conversion
		extend ActiveModel::Naming

		attr_accessor :name, :user, :account, :pass

		validates :name, inclusion: { in: %w(SCOTIA BICE), message: "%{value} es desconocido" }
		validates :user, presence: true
		validates :account, presence: true
		validates :pass, presence: true

		def initialize(attributes = {})
			attributes.each do |name, value|
				send("#{name}=", value)
			end
		end

		def create_bank! client
			raise "Corrige los errores" unless valid?
			Apibanca::Bank.create client, to_params
		end

		private
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
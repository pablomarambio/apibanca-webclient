module Mockups
	class Base
		include ActiveModel::Validations
		include ActiveModel::Conversion
		extend ActiveModel::Naming

		def initialize(attributes = {})
			attributes.each do |name, value|
				send("#{name}=", value)
			end
		end

		protected
		def copy_remote_errors remote_errors
			puts remote_errors.keys
			remote_errors.keys.each do |attribute|
				remote_errors[attribute].each do |error|
					errors.add attribute, error
				end
			end
		end
	end
end
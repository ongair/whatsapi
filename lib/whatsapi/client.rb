module Whatsapi
	class Client

		attr_accessor :phone_number, :identity, :name

		def initialize(phone_number, identity, name)
			
			raise ArgumentError.new('name must be provided') if blank?(name)
			raise ArgumentError.new('phone_number must be provided') if blank?(phone_number)

			@phone_number = phone_number
			@identity = identity
			@name = name
		end

		private 

		def blank? val
			(val.nil? or val.empty?)
		end
	end
end
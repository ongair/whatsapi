module Whatsapi
	class Client

		attr_accessor :phone_number, :identity, :name

		def initialize(phone_number, identity, name)
			@phone_number = phone_number
			@identity = identity
			@name = name
		end
	end
end
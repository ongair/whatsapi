require 'digest/sha1'
require 'uri'

module Whatsapi
	class Client

		attr_accessor :phone_number, :identity, :name

		def initialize(phone_number, identity, name)
			
			raise ArgumentError.new('name must be provided') if blank?(name)
			raise ArgumentError.new('phone_number must be provided') if blank?(phone_number)

			@phone_number = phone_number
			@name = name

			# check identity
			if is_valid_identity?(identity)
				@identity = identity
			else
				@identity = create_identity
			end			
		end

		private 

		def blank? val
			(val.nil? or val.empty?)
		end

		# A valid identity is always 20 characters long with
		# encoding stripped
		def is_valid_identity?(identity)
			identity = "" if identity.nil?
			URI.decode(identity).length == 20
		end

		# Create an identifier by calculating the 
		# sha1 hash without binaray output
		def create_identity
			Digest::SHA1.hexdigest @phone_number
		end
	end
end
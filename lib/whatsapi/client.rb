# encoding: utf-8
require 'digest/sha1'
require 'uri'
require 'socket'

module Whatsapi
	class Client

		attr_accessor :phone_number, :identity, :name, :login_status, :socket, :reader, :writer, :challenge_data

		# Initialize the WhatsApp client
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

			@login_status = Whatsapi::Constants::DISCONNECTED_STATUS
			@writer = Whatsapi::BinTreeWriter.new()
			@reader = Whatsapi::BinTreeReader.new()
		end

		# Opens a socket connection to 
		# whatsapp on the configured location and post
		# TODO: Timeouts?
		# 
		def connect
			@socket ||= TCPSocket.new(Whatsapi::Constants::WHATSAPP_HOST, Whatsapi::Constants::PORT)			
		end

		def login password
			@password = password
			get_challenge_data

			do_login			
		end

		private 

		def do_login
			@writer.reset_key!
			@reader.reset_key!

			resource = "#{Whatsapi::Constants::WHATSAPP_DEVICE}-#{Whatsapi::Constants::WHATSAPP_VER}-#{Whatsapi::Constants::PORT}"
			@writer.start_stream(Whatsapi::Constants::WHATSAPP_SERVER, resource)
		end

		# The challenge data file should be configurable
		# as its not always going to be in the same place
		def get_challenge_data
			@challenge_data = IO.read(Whatsapi.config.challenge_file_path)
		end

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
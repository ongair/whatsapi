require "whatsapi/version"
module Whatsapi
	class BinTreeWriter
		attr_accessor :key, :output

		def reset_key!
			@key = nil
		end
	end
end
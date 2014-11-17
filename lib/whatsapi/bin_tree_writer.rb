# encoding: utf-8
require 'whatsapi/version'
require 'whatsapi/bin_tree'
require 'whatsapi/token_map'
require 'whatsapi/protocol_node'

module Whatsapi
	class BinTreeWriter < BinTree
		attr_accessor :output

		def initialize
			@output = ""
		end

		def start_stream domain, resource
			attributes = {}
			header = "WA"
			header += write_int8(1)
			header += write_int8(4)

			attributes['to'] = domain
			attributes['resource'] = resource

			write_list_start(attributes.length * 2 + 1)

			@output += "\x01"
			write_attributes(attributes)
			result = header + flush_buffer 
			result
		end

		def flush_buffer encrypt=true
			size = @output.length
			data = @output

			
			if !@key.nil? && encrypt
				bsize = get_int24(size)

				# encrypt
				data = @key.encode_message(data, size, 0, size)
				len = data.length

				bsize[0] = ((8 << 4) | ((len & 16711680) >> 16)).chr
				bsize[1] = ((len & 65280) >> 8).chr
				bsize[2] = (len & 255).chr
				size = parse_int24(bsize)				
			end
			result = write_int24(size) + data
			@output = ""
			result
		end

		def create_features_node
			parent = ProtocolNode.new("stream:features", nil, nil, nil)
			parent
		end

		def write_attributes attributes
			attributes.keys.each do |key|
				write_string key
				write_string attributes[key]
			end
		end

		def write_string tag			
			found, main, index = TokenMap.try_get_token(tag, false)
			if found
				if main
					write_token(236)
				end
				write_token(index)
				return
			end
			idx = tag.index('@')
			if idx
				server = tag[idx+1..-1]
				user = tag[0, idx]
				write_jid(user, server)
			else
				write_bytes tag
			end
		end

		def write_jid user, server			
			@output += "\xfa"
			if user.length > 0
				write_string user
			else
				write_token 0
			end
			write_string server
		end

		def write_bytes bytes
	        len = bytes.length
	        if len >= 0x100
	        	@output += "\xfd"
	        	@output += write_int24(len)
	        else
	        	@output += "\xfc"
	        	@output += write_int8(len)
	        end
	        @output += bytes
		end

		def write_list_start count
			if count == 0
				@output += "\x00";
			elsif count < 256
				@output += "\xf8" + count.chr
			else
				@output += "\xf9" + write_int16(count)
			end
		end

		def write_token token
			if token < 0xf5				
				@output += token.chr
			elsif token <= 0x1f4
				@output += "\xfe" + (token - 0xf5).chr
			end
		end

		def write_int8 int
			int.chr
		end

		def write_int16 int
			result = ((int & 0xff00) >> 8).chr(Encoding::UTF_8)
			result += ((int & 0x00ff) >> 0).chr(Encoding::UTF_8)
			return result
		end

		def write_int24 int
	        result = ((int & 0xff0000) >> 16).chr(Encoding::UTF_8)
	        result += ((int & 0x00ff00) >> 8).chr(Encoding::UTF_8)
	        result += ((int & 0x0000ff) >> 0).chr(Encoding::UTF_8)
	        result
		end

		def clear_output
			@output = ""
		end

		def get_int24 length
			result = ((length & 0xf0000) >> 16).chr(Encoding::UTF_8)
			result += ((length & 0xff00) >> 8).chr(Encoding::UTF_8)
			result += (length & 0xff).chr(Encoding::UTF_8)
			return result
		end

		def parse_int24 data
	  		result = data[0,1].ord << 16
	  		result |= data[1,1].ord << 8
	  		result |= data[2,1].ord << 0
	  		result
		end
	end
end
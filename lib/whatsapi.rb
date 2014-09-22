require "whatsapi/version"
require "active_support"

module Whatsapi
	include ActiveSupport::Configurable
	
	autoload :Constants, 'whatsapi/constants'
	autoload :Client, 'whatsapi/client'
	autoload :BinTreeWriter, 'whatsapi/bin_tree_writer'
	autoload :BinTree, 'whatsapi/bin_tree'
end

Whatsapi.configure do |c|
  c.challenge_file_path = Whatsapi::Constants::CHALLENGE_FILE_NAME
end

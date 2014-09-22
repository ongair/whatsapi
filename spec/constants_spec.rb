require 'spec_helper'


describe Whatsapi::Constants do
	it 'Uses the correct constants' do

		expect(Whatsapi::Constants::CONNECTED_STATUS).to eq('connected') 
		expect(Whatsapi::Constants::DISCONNECTED_STATUS).to eq('disconnected') 
		expect(Whatsapi::Constants::PORT).to eq(443) 

		# TODO: complete the remaining variable constants

	end
end
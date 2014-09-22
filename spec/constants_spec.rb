require 'spec_helper'


describe Whatsapi::Constants do
	it 'Uses the correct constants' do

		expect(Whatsapi::Constants::CONNECTED_STATUS).to eq('connected') 
		expect(Whatsapi::Constants::DISCONNECTED_STATUS).to eq('disconnected') 
		expect(Whatsapi::Constants::PORT).to eq(443) 
		expect(Whatsapi::Constants::TIMEOUT_USEC).to eq(0) 
		expect(Whatsapi::Constants::TIMEOUT_SEC).to eq(2) 
		expect(Whatsapi::Constants::CHALLENGE_FILE_NAME).to eq('nextChallenge.dat') 

		# TODO: complete the remaining variable constants

	end
end
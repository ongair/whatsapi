require 'spec_helper'


describe Whatsapi::Client do
	subject { 
		Whatsapi::Client.new(
			'254705866565',
			'a262eb2b404bc3f15144c6c4ae6ebc45fac98eba',
			'Sprout')
	}

	it { expect(subject.phone_number).to eql('254705866565') }
	it { expect(subject.identity).to eql('a262eb2b404bc3f15144c6c4ae6ebc45fac98eba') }
	it { expect(subject.name).to eql('Sprout') }
end
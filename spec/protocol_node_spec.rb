require 'spec_helper'

describe Whatsapi::ProtocolNode do
	describe 'Features node' do
		subject { Whatsapi::ProtocolNode.new("stream:features", nil, nil, nil) }

		it { expect(subject.is_cli).to be true }
		it { expect(subject.tag).to eql("stream:features") }
		it { expect(subject.attributes).to be nil }
		it { expect(subject.children).to be nil }
		it { expect(subject.data).to be nil }
	end

	describe 'Auth node' do
	end
end
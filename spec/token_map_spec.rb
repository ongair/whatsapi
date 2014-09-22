require 'spec_helper'

describe Whatsapi::TokenMap do

	it { expect(Whatsapi::TokenMap.try_get_token('account',false, 0)).to eql([true, false, 3]) }
	it { expect(Whatsapi::TokenMap.try_get_token('full',false, 0)).to eql([true, true, 11]) }
	it { expect(Whatsapi::TokenMap.try_get_token('not_there',false, 0)).to eql([false, false, nil]) }
end
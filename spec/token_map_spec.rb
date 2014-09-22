require 'spec_helper'

describe Whatsapi::TokenMap do

	it { expect(Whatsapi::TokenMap.try_get_token('account')).to eql([true, false, 3]) }
	it { expect(Whatsapi::TokenMap.try_get_token('full')).to eql([true, true, 11]) }
	it { expect(Whatsapi::TokenMap.try_get_token('not_there')).to eql([false, false, nil]) }

	found, main, index = Whatsapi::TokenMap.try_get_token('account')	
	it { expect(Whatsapi::TokenMap.get_token(index, main)).to eql(['account', false]) }
end
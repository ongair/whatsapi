require 'spec_helper'

describe Whatsapi::TokenMap do

	it { expect(Whatsapi::TokenMap.try_get_token('account',false, 0)).to be_true }
end
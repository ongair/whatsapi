require 'spec_helper'
require 'socket'

describe Whatsapi::BinTreeWriter do

	subject { Whatsapi::BinTreeWriter.new() }

	describe  "Writing integers" do
		it { expect(subject.output).to eql("") }
		it { expect(subject.write_int8(1)).to eql("\u0001") }
		it { expect(subject.write_int16(1)).to eql("\u0000\u0001") }
	end

	describe "Write list start" do

		it "Writes the start of the list correctly" do
			writer = Whatsapi::BinTreeWriter.new()			
			
			# zero characters
			writer.write_list_start(0)

			expect(writer.output).to eql("\x00")

			writer.clear_output
			expect(writer.output).to eql("")

			# 5 characters
			writer.write_list_start(5)
			expect(writer.output).to eql("\xf8\u0005")

			# 270 characters
			writer.clear_output
			writer.write_list_start(270)
			
			expect(writer.output).to eql("\xf9" + writer.write_int16(270))

		end
	end
end
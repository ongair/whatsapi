# encoding: utf-8
require 'spec_helper'
require 'socket'

describe Whatsapi::BinTreeWriter do

	subject { Whatsapi::BinTreeWriter.new() }

	describe  "Writing integers" do
		it { expect(subject.output).to eql("") }
		it { expect(subject.write_int8(1)).to eql("\u0001") }
		it { expect(subject.write_int16(1)).to eql("\u0000\u0001") }
		it { expect(subject.write_int24(1)).to eql("\u0000\u0000\u0001") }
		it { expect(subject.get_int24(1)).to eql("\u0000\u0000\u0001") }
	end

	describe "Write list start" do

		let(:resource) { "#{Whatsapi::Constants::WHATSAPP_DEVICE}-#{Whatsapi::Constants::WHATSAPP_VER}-#{Whatsapi::Constants::PORT}" }		

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

		it "Should start a stream correctly" do
			writer = Whatsapi::BinTreeWriter.new()			
			
			result = writer.start_stream(Whatsapi::Constants::WHATSAPP_SERVER, resource)
			# expect(result).to eql("WA?¤?Android-2.11.399-4")
		end
	end
end
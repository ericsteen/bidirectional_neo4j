require 'spec_helper'
require_relative '../lib/user_worker.rb'

describe UserWorker do
	
	describe "#perform" do

		it "allows numeric characters to be inserted" do
			expect(UserWorker).not_to receive(:determine_error)
			expect {subject.perform([{"user_a_id" => 11, "user_b_id" => 12}])}.not_to raise_error
		end

		it "does not allow special characters to be inserted" do
			expect {subject.perform([{"user_a_id" => "§", "user_b_id" => "''"}])}.to raise_error(Exceptions::NonIntegerError)
			expect {subject.perform([{"user_a_id" => "''", "user_b_id" => "$"}])}.to raise_error(Exceptions::NonIntegerError)
		end

		it "does not allow empty string characters to be inserted" do
			expect {subject.perform([{"user_a_id" => 1, "user_b_id" => "''"}])}.to raise_error(Exceptions::NonIntegerError)
		end

		it "does not allow alphanumeric characters to be inserted" do
			expect {subject.perform([{"user_a_id" => 3, "user_b_id" => "test"}])}.to raise_error(Exceptions::NonIntegerError)
		end
	end

end
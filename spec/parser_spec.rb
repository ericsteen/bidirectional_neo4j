require 'spec_helper'
require_relative '../lib/parser.rb'

describe Parser do

  let(:filename) { "spec/fixtures/users.csv" }

  subject do
    Parser.new(filename)
  end

  describe "initialization" do 
    it "inits with csv filename to parse" do
      expect(subject.filename).to eq(filename)
    end
  end

  describe "#process_file" do

    it "processes chunks of a file in parallel" do
      expect(UserWorker).to receive(:perform_async)
      subject.process_file
    end

  end

end
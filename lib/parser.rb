require 'smarter_csv'
require 'byebug'

class Parser
	attr_reader :filename

	def self.notify(ex, ctx_hash)
		File.open("errors.txt", 'w') { |file| file.write("#{ex}/n") }
	end

	def initialize(filename)
		@filename = filename
	end

	def process_file
		::SmarterCSV.process(filename, {:comment_regexp => /^#/, :chunk_size => 200}) do |chunk|
		  UserWorker.perform_async(chunk) # pass chunks of CSV-data to sidekiq workers for parallel processing
		end
	end
end


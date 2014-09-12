require 'rubygems'
require 'sidekiq'

require_relative 'lib/parser.rb'
require_relative 'lib/config.rb'
require_relative 'lib/user_worker.rb'

p = Parser.new('spec/fixtures/users.csv').process_file
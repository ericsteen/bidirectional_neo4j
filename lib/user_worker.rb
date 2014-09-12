require 'neography'
require 'sidekiq'
require 'sidekiq/web'
require_relative 'exceptions.rb'

class UserWorker
	include Sidekiq::Worker

	def neo
		@neo ||= ::Neography::Rest.new
	end

	def perform(chunk)
		chunk.each do |buddies|
			user_a_id = buddies["user_a_id"]
			user_b_id = buddies["user_b_id"]
			determine_id_error(user_a_id) unless user_a_id.to_s.match(/\A[0-9]+\Z/)
			determine_id_error(user_b_id) unless user_b_id.to_s.match(/\A[0-9]+\Z/)
			begin
				node1 = neo.get_node(user_a_id)
			  node2 = neo.get_node(user_b_id)
			rescue Neography::NodeNotFoundException => e
			  node1 = neo.create_node(id: user_a_id) unless node1 && node1.exist?
				node2 = neo.create_node(id: user_b_id) unless node2 && node2.exist?
			end
			#TODO: create relationship unless relationship already exists
			neo.create_relationship("coding_buddies", node1, node2)
		end
	end

	def determine_id_error(id)
		error_info = {}
		error_info[:id] = id.nil? ? "nil" : id
		raise Exceptions::NonIntegerError.new(error_info) 
	end
end
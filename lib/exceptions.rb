module Exceptions

  class NonIntegerError < StandardError
    attr_reader :error_info
    def initialize(error_info={})
      @error_info = error_info
    end

    def message
      if error_info[:id]
        "Non Integer column data (id: #{error_info[:id]}): CSV must be in format user_a_id, user_b_id with only integer column data"
      end
    end
  end
end
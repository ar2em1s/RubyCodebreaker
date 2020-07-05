# frozen_string_literal: true

module Codebreaker
  class User
    include Validator
    include GameConfiguration

    attr_reader :name

    def initialize(name)
      @name = name

      validate_data
    end

    private

    def validate_data
      validate_name
    end

    def validate_name
      validate_class(String, @name)
      validate_string_length(string: @name, min_length: USERNAME_MIN_LENGTH, max_length: USERNAME_MAX_LENGTH)
    end
  end
end

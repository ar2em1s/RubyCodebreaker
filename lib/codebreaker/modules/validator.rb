# frozen_string_literal: true

module Codebreaker
  module Validator
    def validate_class(expected_class, instance_class)
      message = "Not expected class. Expected #{expected_class} class, but was #{instance_class} class"
      raise_error(CodebreakerArgumentError, message) unless expected_class == instance_class
    end

    def validate_class_or_nil(expected_class, instance_class)
      message = "Not expected class. Expected #{expected_class} class or NilClass, but was #{instance_class} class"
      raise_error(CodebreakerArgumentError, message) unless [expected_class, NilClass].include?(instance_class)
    end

    def validate_non_empty_string(string)
      message = 'String was empty'
      raise_error(CodebreakerArgumentError, message) if string.empty?
    end

    def validate_positive_integer(number)
      message = 'Integer was not positive'
      raise_error(CodebreakerArgumentError, message) unless number.positive?
    end

    def validate_non_negative_integer(number)
      message = 'Integer was negative'
      raise_error(CodebreakerArgumentError, message) if number.negative?
    end

    def validate_string_length(string:, min_length:, max_length: nil)
      if max_length.nil?
        message = "String length was less than #{min_length}"
        raise_error(CodebreakerArgumentError, message) if string.length < min_length
      else
        message = "String length was not in range: #{min_length}-#{max_length}"
        raise_error(CodebreakerArgumentError, message) if string.length < min_length || string.length > max_length
      end
    end

    def raise_error(error_class, message)
      raise error_class, message
    end
  end
end
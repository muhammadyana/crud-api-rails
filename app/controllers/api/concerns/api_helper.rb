# TODO: no docs
module Api
  module Concerns
    module ApiHelper
      extend ActiveSupport::Concern

      def default_message
        {
          :ok => 'Success',
          :created => 'Resource created',
          :not_found => 'Resource not found',
          :bad_request => 'Bad request',
          :unauthorized => 'Unauthorized access',
          :unprocessable_entity => 'Bad request format',
          :resource_conflict => 'Resource already existed'
        }
      end

      # Shorthand method for returning json responses.
      #
      # @param code (symbol) - Rails status code symbols.
      # @param message (string) - Custom message.
      # @param args (Hash) - Additional parameters to be attached in the body.
      def responder(code=:ok, message=nil, args=nil)
        message ||= default_message[code]
        args ||= {}
        if code == :ok
          return render json: {status: 'success', success: true, message: message}.merge(args), status: code
        else
          return render json: {status: 'error', errors: message, success: false, message: message}.merge(args), status: code
        end
      end

      ##
      # Grabs error messages and turn them into array of string. For example,
      # ActiveRecord::RecordInvalid only provide:
      #   "Validation failed: X can't be blank, Y can't be blank"
      # Expected output is { errors: ["X can't be blank", "Y can't be blank"] }
      #
      # @param error (Error) - Error object
      # @return Hash
      ##
      def errors_from error
        if error.respond_to? :message
          # Handle StandardError objects
          errors = error.message.split(': ').last.split(', ')
          { errors: errors }
        elsif error.respond_to? :full_messages
          # Handle ActiveRecord validation errors
          { errors: error.full_messages }
        end
        {} # return empty hash as default
      end

      def android_device?
        params[:device_type] == 'android'
      end
      
      ##
      # Builds strong parameter from request parameter, only containing what's in the permitted
      # keys. The downside of this method is it always instantiates ActionController::Parameters and
      # it recursively calls itself for any nested parameter objects/array.
      #
      # @param params (Hash) - Parameter received from request
      # @param permitted_keys (Array) - Array containing strong params' permitted attributes
      # @return ActionController::Parameters
      ##
      def build_params(params, permitted_keys=nil)
        raise 'Expected arg 1 to be Array' unless %w(NilClass Array).include? permitted_keys.class.to_s
        return params if permitted_keys.blank? || params.blank?

        # Process each object inside the array using the same permitted keys.
        if params.instance_of? Array
          return params.map{|param| build_params(param, permitted_keys)}
        end

        filtered_params = {}
        permitted_keys.inject(filtered_params) do |store, item|
          if item.instance_of? Hash
            # handle nested permit cases, e.g.: permit(:a => [:b, :c, :d])
            item.keys.each do |key|
              store[key] = build_params(params[key], item[key]) if params[key].present?
            end
          elsif !params[item].nil?
            # add if item is a symbol and params contains item
            store[item] = params[item]
          end
          store
        end

        ActionController::Parameters.new(filtered_params).permit(permitted_keys)
      end

    end
  end
end

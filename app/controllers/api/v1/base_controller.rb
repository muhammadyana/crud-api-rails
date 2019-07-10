# encoding: utf-8

module Api
  module V1
    class BaseController < ApplicationController
      include Api::Concerns::ApiHelper
      include Pagy::Backend

      # layout false
      # respond_to :json

      rescue_from Exception,                           with: :render_error unless Rails.env.development?
      rescue_from ActiveRecord::RecordNotFound,        with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid,         with: :render_record_invalid
      rescue_from ActionController::RoutingError,      with: :render_not_found
      rescue_from AbstractController::ActionNotFound,  with: :render_not_found
      rescue_from ActionController::ParameterMissing,  with: :render_parameter_missing

      def status
        render json: { online: true }
      end

      private

      def render_error(exception)
        raise exception if Rails.env.test?

        # To properly handle RecordNotFound errors in views
        if exception.cause.is_a?(ActiveRecord::RecordNotFound)
          return render_not_found(exception)
        end

        logger.error("==== Error Log #{exception}") # Report to your error managment tool here
        render json: { error: I18n.t('api.errors.server'), success: false }, status: 500 unless performed?
      end

      def render_not_found(exception)
        logger.info("==== Error Log #{exception}") # for logging
        render json: { error: I18n.t('api.errors.not_found'), success: false }, status: :not_found
      end

      def render_record_invalid(exception)
        logger.info(exception) # for logging
        render json: { errors: exception.record.errors.as_json, success: false }, status: :bad_request
      end

      def render_parameter_missing(exception)
        logger.info(exception) # for logging
        render json: { error: I18n.t('api.errors.missing_param'), success: false }, status: :unprocessable_entity
      end
      
    end
  end
end

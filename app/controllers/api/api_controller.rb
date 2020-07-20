module Api
  class ApiController < ActionController::API
    include DeviseTokenAuth::Concerns::SetUserByToken
    include ApiErrorHelpers
    include ApiResponseHelpers

    rescue_from StandardError, with: :render_internal_error
    rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

    def render_record_not_found
      error_msg = { record_not_found: ['Record Not Found'] }
      render_error('Record Not Found', false, 404, error_msg)

      return if performed?
    end
  end
end

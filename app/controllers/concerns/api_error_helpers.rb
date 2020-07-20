module ApiErrorHelpers
  extend ActiveSupport::Concern

  def render_internal_error(error)
    Rails.logger.error("[API Error] Message: #{error.full_message}")

    message = "Internal Server Error - Class: #{error.class}"

    render_error(message, false, 500)
  end

  def render_error(msg, success, status, error_details = [])
    json = {
      message: msg,
      success: success,
      errors: {}
    }
    json[:errors] = error_by_model(error_details) if error_details.present?
    render json: json, status: status
  end

  def error_by_model(error_details)
    return error_details unless error_details.try(:messages).present?

    errors = {}

    error_details.keys.each do |attribute|
      errors[attribute] = error_details[attribute].map do |msg|
        "#{attribute.to_s.humanize} #{msg}"
      end
    end

    errors
  end
end

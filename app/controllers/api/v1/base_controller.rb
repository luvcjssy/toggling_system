module Api
  module V1
    class BaseController < ApiController
      # before_action :authenticate_user!

      class UnauthorizedError < StandardError; end
      rescue_from UnauthorizedError do |e|
        error_msg = { unauthorized: ['You are not allow to do this action'] }
        render_error(:unauthorized, false, 403, error_msg)
      end
    end
  end
end

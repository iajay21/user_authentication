module Api
  module SessionHelper

  	def authenticate_user_from_token
      if request.headers['Authorization'].present?
        begin
          jwt_payload = JWT.decode(request.headers['Authorization'], Rails.application.secrets.secret_key_base).first
          user = User.find(jwt_payload['id'])
          if jwt_payload["iat"] == user.iat
            @current_user_id = jwt_payload['id']
          else
            render json: {errors: "invalid token"}, status: 422
          end
        rescue JWT::ExpiredSignature
          if request.path == "/api/auth/renew_token"
            render json: {errors: "refresh token expired!"}, status: 403
          else
            render json: {errors: "access token expired!"}, status: 401
          end
        rescue JWT::VerificationError, JWT::DecodeError
          render json: {errors: "unauthorized"}, status: 401
        end
      else
        render json: {errors: "empty or invalid token!"}, status: 422
      end
    end

    def api_current_user
      @current_user ||= User.find(@current_user_id)
    end

    def api_signed_in?
      @current_user_id.present?
    end
  end
end

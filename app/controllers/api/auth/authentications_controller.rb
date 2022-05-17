class Api::Auth::AuthenticationsController < Api::ApplicationController
  skip_before_action :authenticate_user_from_token, only: [:signup, :signin]

  def signup
    user = User.new(signup_params)
    if user.save
      render json: {data: {
        user_id: user.id,
        name: user.name,
        email: user.email
      }, message: "success"}, status: 200
    else
      render json: {errors: user.errors.full_messages}, status: 400
    end
  end

  def signin
    user = User.find_for_database_authentication(email: params[:user][:email])
    if user.present? 
      if user.valid_password?(params[:user][:password])
        unless user.update_signin_info
          return render json: {error: user.errors.full_messages }, status: 422
        end
        @current_user = user
        render json: {data: {
          user_id: user.id, 
          email: user.email,
          name: user.name,
          access_token: user.generate_access_token,
          refresh_token: user.generate_refresh_token
        }, message: "success"}, status: 200
      else
        render json: {error: "invalid credentials" }, status: 422
      end
    else
      render json: {error: "user not found" }, status: 404
    end
  end

  def renew_token
    if api_current_user.present?
      user = api_current_user
      if user.update_signin_time
        render json: {data: {access_token: user.generate_access_token, refresh_token: user.generate_refresh_token}, message: "success"}, status: 200
      end
    else
      render json: {error: "invalid credentials" }, status: 422
    end
  end
  
  private

  def signup_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

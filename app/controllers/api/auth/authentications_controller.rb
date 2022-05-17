class Api::Auth::AuthenticationsController < Api::ApplicationController
  skip_before_action :authenticate_user_from_token, only: [:signup, :signin]

  swagger_controller :authentications, 'Authentications'

  def self.add_common_params(api)
    api.param :form, "user[email]", :string, :optional, "email"
    api.param :form, "user[password]", :string, :optional, "password"
  end

  swagger_api :signup do
    summary 'User Sign Up'
    param :form, "user[name]", :string, :required, "name"
    param :form, "user[email]", :string, :required, "email"
    param :form, "user[password]", :string, :required, "password"
    param :form, "user[password_confirmation]", :string, :required, "password confirmation"
    response :ok
    response :not_acceptable
    response :unprocessable_entity
  end

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

  swagger_api :signin do |api|
    summary 'User Sign In'
    Api::Auth::AuthenticationsController::add_common_params(api)
    response :unauthorized
    response :not_acceptable
    response :unprocessable_entity    
    response :not_found
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

  swagger_api :renew_token do
    summary 'User Renew Token'
    param :header, 'Authorization', :string, :required, 'Authentication Token'
    response :unauthorized
    response :unprocessable_entity    
    response :not_found
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

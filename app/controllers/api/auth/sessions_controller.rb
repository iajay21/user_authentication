class Api::Auth::SessionsController < Devise::SessionsController

  def create
    user = User.find_by_email(params[:email])

    if user && user.valid_password?(params[:password])
      user.update_signin_info
      @current_user = user
      render json: {data: {
          user_id: user.id, 
          email: user.email,
          name: user.name,
          access_token: user.generate_access_token,
          refresh_token: user.generate_refresh_token
        }, message: "Success"}, status: 200
    else
      render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
    end
  end
end
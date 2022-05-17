class Api::V1::UsersController < Api::ApplicationController

  def self.add_common_params(api)
    api.param :form, "user[name]", :string, :optional, "name"
    api.param :form, "user[email]", :string, :optional, "email"
  end

  swagger_controller :users, 'Users'

  swagger_api :show do
    summary 'return user detail '
  end

  def show
  end

  swagger_api :update do |api|
    summary 'update user detail '
    Api::V1::UsersController::add_common_params(api)
    response :unauthorized
    response :not_acceptable
    response :unprocessable_entity    
    response :not_found
  end

  def update
    if api_current_user.update(user_params)
      render :show
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
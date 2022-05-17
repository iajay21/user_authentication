class Api::V1::UsersController < Api::ApplicationController

  swagger_controller :users, 'Users'

  swagger_api :show do
    summary 'return user detail '
    notes 'Notes...'
  end

  def show
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
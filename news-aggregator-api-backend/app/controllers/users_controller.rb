class UsersController < ApplicationController
  def create
    if params[:password] != params[:password_confirmation] || !params[:password] || !params[:password_confirmation] || params[:password] != ""
      redirect_to '/users/new'
    end
    session[:user_id] = User.create(user_params).id
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end

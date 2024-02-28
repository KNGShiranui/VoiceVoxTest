class UsersController < ApplicationController
  before_action :set_user, only: %i[show]

  def index
    @users = User.all
  end

  def show
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end

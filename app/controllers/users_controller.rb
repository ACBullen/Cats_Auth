class UsersController < ApplicationController
  def new
    render :new
  end

  before_action do
    redirect_to cats_url if current_user
  end
  def create
    @user = User.new(user_params)

    if @user.valid?
      @user.save
      log_in!
    else
      flash[:errors] << errors.full_mesages
      redirect_to users_url

    end
  end

  def show
    @user = User.find(params[:id])

    if @user
      render :show
    else
      flash[:errors] << @user.errors.full_mesages
      redirect_to cats_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end

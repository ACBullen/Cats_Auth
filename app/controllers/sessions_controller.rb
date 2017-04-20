class SessionsController < ApplicationController

  def check_user
    redirect_to cats_url if current_user
  end

  before_action :check_user, only: [:new, :create]

  def new
    render :new
  end

  def create
    log_in!
  end

  def destroy
    if current_user
      current_user.reset_session_token!
      session[:session_token] = nil
      redirect_to cats_url
    else
      flash[:errors] += ["Invalid credentials."]
      redirect_to cats_url
    end
  end
end

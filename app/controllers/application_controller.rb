class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
   protect_from_forgery with: :exception

   helper_method :current_user
   helper_method :owner_matches_cat

   def owner_matches_cat
     if current_user.cats.where(id: params[:id]).empty?
       false
     else
       true
     end
   end

   def current_user
     @session ||= Session.includes(:user).find_by(session_token: session[:session_token])
     if @session.nil?
       nil
     else
       @session.user
     end
   end

   def log_in!
     @user = User.find_by_credentials(params[:user][:username], params[:user][:password])
     if @user
      session = Session.new(
        user_id: @user.id,
        user_agent: request.env["HTTP_USER_AGENT"],
        session_token: Session.generate_session_token,
        ip_address: request.remote_ip,)
      session.save

      session[:session_token] = session.session_token
      redirect_to cats_url
     else


       redirect_to new_session_url
     end
   end
end

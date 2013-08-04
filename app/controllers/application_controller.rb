class ApplicationController < ActionController::Base
  protect_from_forgery

  
  protected

  def confirm_logged_in
    unless session[:id]
      flash[:notice] = "Please log in."
      redirect_to(:controller => 'user', :action => 'sign_in')
      return false # halts the before_filter
    else
      @user=User.find(session[:id])
      return true
    end
  end
  
end

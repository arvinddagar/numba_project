class UserController < ApplicationController
  before_filter :confirm_logged_in, :except => [:create,:sign_in]
def create
  @user = User.new()
  return unless request.post?
  @user = User.new(user_params)
  if  @user.save
    flash[:notice] = 'User was successfully created.'
    redirect_to :controller=>'home', :action => 'index'
  else
    render action: 'create'
  end
end

def sign_in
  return unless request.post?
  authorized_user = User.authenticate(params[:email], params[:password])
    if authorized_user
      session[:id] = authorized_user.id
      flash[:notice] = "You are now logged in."
      redirect_to :controller=>'home', :action => 'index'
    else
      flash[:notice] = "Invalid username/password combination."
      redirect_to :controller=>'home', :action => 'index'
   end
end

def logout
    session[:id] = nil
    flash[:notice] = "You have been logged out."
    redirect_to(:controller=> 'home',:action => 'index')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email)
    end
end

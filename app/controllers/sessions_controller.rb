class SessionsController < ApplicationController
  before_action :check_user_activated, only: [:create]

  def new
  end

  def create
    if @user.authenticate(params[:session][:password])
      log_in @user
      remember @user if params[:session][:remember_me] == '1'
      # 原设计
      # params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

    # 验证当前要登录的用户是否已经激活
    def check_user_activated
      @user = User.find_by email: params[:session][:email].downcase
      flash.now[:danger] = <<INFO and render :new and return unless @user
'Email is unregistered.'
INFO
      unless @user.activated?
        flash[:warning] = <<INFO, <<ACTION
Account not activated.
INFO
Check your email for the activation link.
ACTION
        redirect_to root_url
      end
    end
end
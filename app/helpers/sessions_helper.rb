module SessionsHelper
  # 登入指定的用户
  def log_in(user)
    session[:user_id] = user.id
  end

  # 返回当前登录用户
  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

  # 判断用户是否登录
  # @return 如果已登录返回true，否则返回false
  def logged_in?
    !current_user.nil?
  end

  # 退出当前用户
  def log_out
    session.delete :user_id
    @current_user = nil
  end
end

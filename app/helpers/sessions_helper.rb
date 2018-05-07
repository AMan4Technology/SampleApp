module SessionsHelper
  # 登入指定的用户
  def log_in(user)
    session[:user_id] = user.id
  end

  # 判断用户是否登录
  # @return 如果已登录返回true，否则返回false
  def logged_in?
    !current_user.nil?
  end

  # 在持久会话中记住用户
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  # 退出当前用户
  def log_out
    forget current_user
    session.delete :user_id
    @current_user = nil
  end

  # 登录cookie中记忆令牌对应的用户并将其返回
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by id: user_id
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by id: user_id
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # 判断用户是否为当前登录用户
  # @return 如果是当前用户则返回true
  def current_user?(user)
    user == current_user
  end

  # 存储当前访问的地址
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  # 重定向到存储的地址或者默认地址
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete :forwarding_url
  end
end

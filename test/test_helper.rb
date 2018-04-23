ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
MiniTest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper

  # 如果用户已经登录，返回true
  def is_logged_in?
    !session[:user_id].nil?
  end

  # 登入指定用户
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest
  # 通过post请求登入指定用户
  def log_in_as(user: nil, password: 'password', remember_me: '1')
    post login_path, params: {session: {email:       user.nil? ? '' : user.email,
                                        password:    password,
                                        remember_me: remember_me}}
  end
end


require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user             = users :michael
    @unactivated_user = users :malory
  end

  test 'should redirect show when user is not activated' do
    get user_path @unactivated_user
    assert_redirected_to root_url
    get user_path @user
    assert_template 'users/show'
  end
end
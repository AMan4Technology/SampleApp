require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users :michael
  end

  test 'profile display' do
    get user_path @user
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_select 'h3', text: "Microposts (#{@user.microposts.count})"
    # assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

  test 'following and followers count' do
    log_in_as user: @user
    get root_path
    assert_select 'a>strong#following', text: @user.following.count.to_s
    assert_select 'a>strong#followers', text: @user.followers.count.to_s
  end
end
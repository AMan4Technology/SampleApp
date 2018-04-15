module UsersHelper
  # @!method 返回指定用户的Gravatar
  # @param user 需要展示的user对象
  # @param size 展示的图片大小，默认为80
  def gravatar_for(user, size: 80)
    gravatar_id  = Digest::MD5::hexdigest user.email.downcase
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?#{size}"
    image_tag gravatar_url, alt: user.name, class: 'gravatar'
  end
end

class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest
  before_save :downcase_email
  validates :name,
            presence: true,
            length:   {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
            presence:   true,
            length:     {maximum: 255},
            format:     {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password,
            presence:  true,
            allow_nil: true,
            length:    {minimum: 6}

  class << self
    # 返回指定字符串的哈希摘要
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    # 返回一个随机令牌
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # 为了持久保存会话，在数据库中记住用户令牌哈希摘要
  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  # 判断指定的令牌和摘要是否匹配
  # @return 匹配则返回true
  def authenticated?(attribute, token)
    digest = send "#{attribute}_digest"
    BCrypt::Password.new(digest).is_password? token unless digest.nil?
  end

  # 忘记用户
  def forget
    update_attribute :remember_digest, nil
  end

  # 发送激活邮件
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # 激活用户
  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  # 发送重置密码邮件
  def send_password_reset_email
    create_reset_digest
    UserMailer.password_reset(self).deliver_now
  end

  # 如果密码重置请求超时了，返回true
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

    def downcase_email
      # self.email = email.downcase
      email.downcase!
    end

  # 创建激活令牌和摘要
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest activation_token
    end

  # 创建重置密码令牌和摘要
    def create_reset_digest
      self.reset_token = User.new_token
      update_columns reset_digest:  User.digest(reset_token),
                     reset_sent_at: Time.zone.now
    end
end
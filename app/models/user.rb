class User < ApplicationRecord
  has_many :microposts 
  # ブラウザを再起動した時にログインできる機能
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_dijest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,length: { maximum: 255 },
   format: { with: VALID_EMAIL_REGEX },
   uniqueness:{ case_sensitive: false }
   has_secure_password
   validates :password, presence: true,length: { minimum:6 }, allow_nil: true  # パスワードが空だった場合

   def User.digest(string)
     cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST:
      BCrypt::Engine.cost
     BCrypt::Password.create(string, cost: cost)
   end

   def User.new_token  # ランダムなトークンを返す
     SecureRandom.urlsafe_base64
   end

   def remember  # ユーザーをデータベースに記録する
     self.remember_token = User.new_token
     update_attribute(:remember_digest, User.digest(remember_token))
   end

   def authenticated?(attribute, token) # 渡されたトークンがダイジェストと一致したらtrueにする
     digest = send("#{attribute}_digest")
     return false if digest.nil?
     BCrypt::Password.new(digest).is_password?(token)
   end

   def forget  # ユーザーのログイン情報を破棄する
     update_attribute(:remember_digest, nil)
   end

   def activate # アカウントを有効化する
     update_attribute(:activated, true)
     update_attribute(:activated_at, Time.zone.now)
   end

   def send_activation_email # 有効化メールを送信する
     UserMailer.account_activation(self).deliver_now
   end

   def create_reset_digest # パスワード再設定の属性を設定
     self.reset_token = User.new_token
     update_attribute(:reset_digest, User.digest(reset_token))
     update_attribute(:reset_sent_at, Time.zone.now)
   end

   def send_password_reset_email # パスワード再設定のメールを送信
     UserMailer.password_reset(self).deliver_now
   end

   def password_reset_expired? # パスワードの再設定の期限
     reset_sent_at < 2.hours.ago
   end

private

   def downcase_email  # メールアドレスを全て小文字にする
     self.email = email.downcase
   end

   def create_activation_dijest
     self.activation_token =  User.new_token
     self.activation_digest = User.digest(activation_token)
   end

end

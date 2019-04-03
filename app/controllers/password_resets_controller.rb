class PasswordResetsController < ApplicationController
   before_action :get_user, only: [:edit, :update]
   before_action :valid_user, only: [:edit, :update]
   before_action :check_expiration, only: [:edit, :update] # パスワードが有効期限切れてないか

  def new
  end

  def create # パスワード再設定
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?  # パスワードが空ではないか
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params) # 正しければアップデート
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit' # それ以外は失敗
    end
  end


  private

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user # 正しいユーザーか確認する
    unless (@user && @user.activated? &&
      @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired"
      redirect_to new_password_reset_url
    end
  end

end

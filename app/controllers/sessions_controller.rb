class SessionsController < ApplicationController
  def new
  end

  def create
    user= User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      # ログインしてユーザーを保持する
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  # ユーザーログアウト
  def destroy
    log_out if logged_in?  # ログイン中のみログアウトする
    redirect_to root_url
  end
end

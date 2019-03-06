module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

# ユーザーがログインしているか検索する
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
      !current_user.nil?
  end

  def logged_out?
    session.delete(:user_id)
    !current_user=nil
  end

end

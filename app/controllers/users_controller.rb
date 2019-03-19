class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit,  :update] #  ログインしたユーザーしか使えない

  def show  # ユーザ一覧を表示
    @user= User.find(params[:id])
  end

  def new
    @user=User.new
  end

  def create　　  # 会員情報を作成するメソッド
    @user = User.new(user_params)
    if @user.save　　#　新期ユーザーを作成する機能
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update #更新する機能
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit' # 更新に失敗した時
    end
  end

private  # 以下はプライベートのパラメータ

  def user_params
    params.require(:user).permit(:name,:email,:password,
      :password_confirmation)

  end

  # beforeアクション

  def logged_in_user   # ログイン済みユーザーか確認する
    unless logged_in?
     flash[:danger] = "Please log in."
     redirect_to login_url
    end
  end

end

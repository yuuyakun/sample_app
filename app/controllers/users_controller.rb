class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update] #  ログインしたユーザーしか使えない
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.all
  end

  def show  # ユーザ一覧を表示
    @user= User.find(params[:id])
  end

  def new
    @user=User.new
  end

  def creat   # 会員情報を作成するメソッド
    @user = User.new(user_params)
    if @user.save    # 新期ユーザーを作成する機能
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update   #更新する機能
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit' # 更新に失敗した時
    end
  end

private  # 以下はプライベートのパラメータ

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)

  end

  # beforeアクション

  def logged_in_user   # ログイン済みユーザーか確認する
    unless logged_in?
     store_location  # リクエスtがあったURLを保管する
     flash[:danger] = "Please log in."
     redirect_to login_url
    end
  end

  def correct_user  # 正しいユーザーか確認する
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)

  end

end

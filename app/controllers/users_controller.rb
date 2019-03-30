class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy] #  ログインしたユーザーしか使えない
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page]) # ページ割
  end

  def show  # ユーザ一覧を表示
    @user= User.find(params[:id])
  end

  def new
    @user=User.new
  end

  def create   # 会員情報を作成するメソッド
    @user = User.new(user_params)
    if @user.save    # 新期ユーザーを作成する機能
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
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

  def destroy  # ユーザーを削除する
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to user_url
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

  def admin_user # 管理者かどうか確認
    redirect_to(root_url) unless current_user.admin?
  end

end

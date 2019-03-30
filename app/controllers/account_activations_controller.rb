class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activateheroku addons:create sendgrid:starter
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "invalid activation link"
      redirect_to root_url
    end
  end

end

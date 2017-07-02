class Admin::UsersController < Admin::BaseAdminController
  def new
    @user = User.new    
  end

  def create
    user = User.new user_params
    if user.save
      ResetPasswordMailWorker.perform_async user.id
      redirect_to admin_root_path
    else
      render :new      
    end
  end

  private
  def user_params
    params.require(:user).permit :email, :password, :password_confirmation
  end
end
class TheAuth::LoginController < TheAuth::BaseController

  def new
    store_location request.referer if request.referer.present?
  end

  def create
    if @user && @user.authenticate(params[:password])
      login_as @user

      redirect_back_or_default
    else
      redirect_back fallback_location: login_url
    end
  end

  def destroy
    logout
    redirect_to root_url
  end

  private
  def set_user
    if params[:login].include?('@')
      @user = User.find_by(email: login)
    else
      @user = User.find_by(mobile: login)
    end
  end

  def inc_ip_count
    Rails.cache.write "login/#{request.remote_ip}", ip_count + 1, :expires_in => 60.seconds
  end

  def ip_count
    Rails.cache.read("login/#{request.remote_ip}").to_i
  end

  def require_recaptcha?
    ip_count >= 3
  end


  private
  def user_params
    params.require(:user).permit(:name,
                                 :email,
                                 :password,
                                 :password_confirmation)
  end

end

class TheAuth::UsersController < TheAuth::BaseController

    def new
      @user = resource.new :password => '' # force client side validation patch
      referer = request.headers['X-XHR-Referer'] || request.referer
      store_location referer if referer.present?
    end

    def create
      @user = resource.new user_params
      if @user.save
        env['warden'].set_user(@user)
        redirect_to main_app.root_url
      else
        render :new, :error => @user.errors.full_messages
      end
    end

    private

    def user_params
      params.require(resource_name).permit(:name, :email, :password, :password_confirmation)
    end

end
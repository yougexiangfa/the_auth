require 'the_auth_base_helper'

module TheAuthController
  extend ActiveSupport::Concern
  include TheAuthBaseHelper

  included do
    helper_method :current_user
  end

  def require_logined
    unless current_user
      store_location
      redirect_to login_url
    end
  end

  def current_user
    @current_user ||= login_from_session
  end

  def check_current_user
    unless current_user
      require_user_from_open('weixin')
    end
  end

  def login_from_session
    resource_class.find_by id: session[:user_id]
  end

  def require_user_from_open(provider="wechat")
    store_location
    redirect_to "/auth/#{provider}"  # 使用oauth2去拿open_id
  end

  #--- 返回 ---
  def redirect_back_or_default(default = root_url)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def login_as(user)
    session[:user_id] = user.id
    @current_user = user
  end



  def forget_me
    cookies.delete(:remember_token)
  end

  def remember_me
    cookies[:remember_token] = {
      :value   => current_user.remember_token,
      :expires => 2.weeks.from_now,
      :httponly => true
    }
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
  end


end
# Application's callback method
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :twitch

  def twitch
    @user = User.from_omniauth(auth_data)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitch') if is_navigational_format?
    else
      session['devise.twitch_data'] = auth_data
      redirect_to root_path, alert: 'User could not be authenticated.'
    end
  end

  def failure
    redirect_to root_path
  end

  private

  def auth_data
    request.env['omniauth.auth']
  end
end

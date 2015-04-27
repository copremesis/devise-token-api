class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  respond_to :json

  # This is our new function that comes before Devise's one
  before_filter :authenticate_user_from_token!
  # This is Devise's authentication
  before_filter :authenticate_user!

=begin
  def after_sign_in_path_for(resource)
    edit_user_registration_path
  end
=end


  private

  def authenticate_user_from_token!
    user_token = params[:user_token].presence || request.headers["x-auth-token"] #my own little fix on this bit
    user       = user_token && User.find_by_authentication_token(user_token.to_s)

    if user
      # Notice we are passing store false, so the user is not
      # actually stored in the session and a token is needed
      # for every request. If you want the token to work as a
      # sign in token, you can simply remove store: false.
      sign_in user, store: false
    end
  end



end

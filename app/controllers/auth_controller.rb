class AuthController < ApplicationController
  before_action :get_token_from_headers, only: [:validate_token, :renew_token, :logout]

  def login
    user = User.find_by(login_name: params[:login_name])
    if user && user.authenticate(params[:password])
      render json: { token: Auth.create_token(user), refresh_token: Auth.create_refresh_token(user) }
    else
      render json: { error: "Invalid login credentials" }, status: :unauthorized
    end
  end

  def logout
    Auth.destroy_token(@token) if @token.present?
    render json: { message: "Logged out" }
  end

  def validate_token
    if @token.present?
      if Auth.valid_token?(@token)
        render json: { success: true }
      else
        render json: { error: "Invalid token" }, status: :unauthorized
      end
    else
      render json: { error: "No token provided" }, status: :unauthorized
    end
  end

  def renew_token
    if @token.present?
      data = Auth.renew_token(@token)
      if data
        render json: data
      else
        render json: { error: "Invalid refresh token" }, status: :unauthorized
      end
    else
      render json: { error: "No token provided" }, status: :unauthorized
    end
  end

  private

  def get_token_from_headers
    @token = request.headers['Authorization']
    @token = @token.split(' ').last if @token
  end

end

# frozen_string_literal: true

class CodeValidationsController < ApplicationController
  before_action :load_user

  def create
    if @user.nil?
      render json: {}, status: :not_found
    else
      token, payload = Warden::JWTAuth::UserEncoder.new.call(@user, :credential, nil)
      whitelist = AllowlistedJwt.new(allowlisted_jwt_params(payload))
      whitelist.save
      render json: { token: token }
    end
  end

  protected

  def load_user
    @user = User.find_by(reset_password_token: code_params)
  end

  def code_params
    params.require(:code)
  end

  def allowlisted_jwt_params(payload)
    {
      user_id: @user.id,
      jti: payload['jti'],
      exp: Time.zone.at(payload['exp']),
      aud: payload['aud']
    }
  end
end
# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe PasswordsController, type: :request do
  before :all do
    @user = create(:user)
  end

  path '/auth/password' do
    post 'Forgot password' do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string }
        },
        required: ['email']
      }
      response '200', 'Ok' do
        let(:params) { { email: @user.email } }
        run_test!
      end
    end
  end
end

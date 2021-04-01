require 'swagger_helper'

RSpec.describe 'api/v1/organizations/{organization_id}/users', type: :request do
  path 'api/v1/organizations/{organization_id}/users' do
    get 'All Organization users' do
      tags 'Organization Users'
      consumes 'application/json'
      response '401', 'Unauthorized' do
        run_test!
      end
    end
  end
end
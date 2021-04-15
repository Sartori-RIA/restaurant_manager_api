require 'swagger_helper'

RSpec.describe Api::V1::WineStylesController, type: :request do
  before :all do
    @admin = create(:super_admin)
    @wine_styles = create_list(:wine_style, 10)
  end

  path '/api/v1/wine_styles' do
    get 'All Wine Styles' do
      tags 'Wine Styles'
      response 200, 'Ok' do
        run_test!
      end
    end
    post 'Create a Wine Style' do
      tags 'Wine Styles'
      security [Bearer: {}]
      parameter in: :body, type: :object,
                schema: {
                  properties: {
                    name: { type: :string }
                  },
                  required: %w[name]
                }
      response 201, 'Created' do
        let(:'Authorization') { auth_header(@admin)['Authorization'] }
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string }
               },
               required: %w[id name]
        run_test!
      end
      response 422, 'Invalid request' do
        let(:Authorization) { "Bearer #{auth_header(user)}" }
        run_test!
      end
    end
  end
  path '/api/v1/wine_styles/{id}' do
    get 'Show Wine Style' do
      tags 'Wine Styles'
      parameter name: :id, in: :path, type: :string
      response 200, 'Ok' do
        run_test!
      end
      response 404, 'Not Found' do
        run_test!
      end
    end
    put 'Update a Wine Style' do
      tags 'Wine Styles'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :string
      parameter in: :body, type: :object,
                schema: {
                  properties: {
                    name: { type: :string }
                  },
                  required: %w[name]
                }
      response 200, 'Ok' do
        let(:'Authorization') { auth_header(@admin)['Authorization'] }
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string }
               },
               required: %w[name]
        run_test!
      end
      response 404, 'Not Found' do
        let(:'Authorization') { auth_header(@admin)['Authorization'] }
        run_test!
      end
      response 422, 'Invalid request' do
        let(:'Authorization') { auth_header(@admin)['Authorization'] }
        run_test!
      end
    end
    delete 'Destroy a Wine Style' do
      tags 'Wine Styles'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :string
      response 204, 'No Content' do
        let(:'Authorization') { auth_header(@admin)['Authorization'] }
        run_test!
      end
      response 404, 'Not Found' do
        let(:'Authorization') { auth_header(@admin)['Authorization'] }
        run_test!
      end
    end
  end
  path '/api/v1/wine_styles/check/style' do
    get 'Check available name' do
      tags 'Wine Styles'
      parameter name: :q, in: :query, type: :string
      response 200, 'Already Exists' do
        run_test!
      end
      response 204, 'Name available' do
        run_test!
      end
    end
  end
end

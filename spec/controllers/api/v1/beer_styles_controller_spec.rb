# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BeerStylesController, type: :request do
  let!(:super_admin) { create(:user, :super_admin) }
  let!(:beer_styles) { create_list(:beer_style, 10) }
  let!(:organization) { create(:organization) }
  let!(:admin) { organization.user }

  describe '#GET /api/beer_styles' do
    it 'requests all beer styles' do
      get api_v1_beer_styles_path, headers: auth_header(admin)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#GET /api/beer_styles/:id' do
    it 'requests beer style by id' do
      get api_v1_beer_style_path(beer_styles.sample.id), headers: auth_header(admin)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#GET /api/beer_styles/check/style' do
    it 'returns :ok status to style in use' do
      get check_style_api_v1_beer_styles_path, params: { q: beer_styles.sample.name }, headers: auth_header(super_admin)
      expect(response).to have_http_status(:ok)
    end

    it 'returns :no_content status to style available' do
      get check_style_api_v1_beer_styles_path, params: { q: Faker::Beer.unique.style },
                                               headers: auth_header(super_admin)
      expect(response).to have_http_status(:no_content)
    end
  end

  describe '#POST /api/beer_styles' do
    it 'creates a beer style' do
      attributes = attributes_for(:beer_style)
      post api_v1_beer_styles_path, params: attributes.to_json, headers: auth_header(super_admin)
      expect(response).to have_http_status(:created)
    end

    it 'throws error with invalid params' do
      post api_v1_beer_styles_path, headers: auth_header(super_admin)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'throws error with invalid params' do
      post api_v1_beer_styles_path, headers: auth_header(admin)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe '#PUT /api/beer_styles/:id' do
    let!(:beer_style) { beer_styles.sample }

    it 'updates a beer style' do
      beer_style.name = 'editado'
      put api_v1_beer_style_path(beer_style.id), params: beer_style.to_json, headers: auth_header(super_admin)
      expect(response).to have_http_status(:ok)
    end

    it 'trows forbidden status' do
      beer_style.name = 'editado'
      put api_v1_beer_style_path(beer_style.id), params: beer_style.to_json, headers: auth_header(admin)
      expect(response).to have_http_status(:forbidden)
    end

    it 'throws error with invalid params' do
      beer_style.name = ''
      put api_v1_beer_style_path(beer_style.id), params: beer_style.to_json, headers: auth_header(super_admin)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe '#DELETE /api/beer_styles/:id' do
    it 'deletes beer style' do
      delete api_v1_beer_style_path(beer_styles.sample.id), headers: auth_header(super_admin)
      expect(response).to have_http_status(:no_content)
    end

    it 'trows forbidden status' do
      delete api_v1_beer_style_path(beer_styles.sample.id), headers: auth_header(admin)
      expect(response).to have_http_status(:forbidden)
    end
  end
end

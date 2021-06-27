# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::WineStylesController, type: :request do
  let!(:super_admin) { create(:user, :super_admin) }
  let!(:wine_styles) { create_list(:wine_style, 10) }
  let!(:organization) { create(:organization) }
  let!(:admin) { organization.user }

  describe '#GET /api/wine_styles' do
    it 'requests all wine styles' do
      get api_v1_wine_styles_path, headers: auth_header(admin)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#GET /api/wine_styles/:id' do
    it 'requests wine style by id' do
      get api_v1_wine_style_path(wine_styles.sample.id), headers: auth_header(admin)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#GET /api/wine_styles/check/style' do
    it 'returns :ok status to style in use' do
      get check_style_api_v1_wine_styles_path, params: { q: wine_styles.sample.name }, headers: auth_header(super_admin)
      expect(response).to have_http_status(:ok)
    end

    it 'returns :no_content status to style available' do
      get check_style_api_v1_wine_styles_path, params: { q: Faker::Beer.unique.style },
                                               headers: auth_header(super_admin)
      expect(response).to have_http_status(:no_content)
    end
  end

  describe '#POST /api/wine_styles' do
    it 'creates a wine style' do
      attributes = attributes_for(:wine_style)
      post api_v1_wine_styles_path, params: attributes.to_json, headers: auth_header(super_admin)
      expect(response).to have_http_status(:created)
    end

    it 'throws error with invalid params' do
      post api_v1_wine_styles_path, headers: auth_header(super_admin)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'trows forbidden status' do
      post api_v1_wine_styles_path, headers: auth_header(admin)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe '#PUT /api/wine_styles/:id' do
    let!(:wine_style) { wine_styles.sample }

    it 'updates a wine style' do
      wine_style.name = 'editado'
      put api_v1_wine_style_path(wine_style.id), params: wine_style.to_json, headers: auth_header(super_admin)
      expect(response).to have_http_status(:ok)
    end

    it 'throws error with invalid params' do
      wine_style.name = ''
      put api_v1_wine_style_path(wine_style.id), params: wine_style.to_json, headers: auth_header(super_admin)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'trows forbidden status' do
      wine_style.name = 'asdasd'
      put api_v1_wine_style_path(wine_style.id), params: wine_style.to_json, headers: auth_header(admin)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe '#DELETE /api/wine_styles/:id' do
    it 'deletes wine style' do
      delete api_v1_wine_style_path(wine_styles.sample.id), headers: auth_header(super_admin)
      expect(response).to have_http_status(:no_content)
    end

    it 'trows forbidden status' do
      delete api_v1_wine_style_path(wine_styles.sample.id), headers: auth_header(admin)
      expect(response).to have_http_status(:forbidden)
    end
  end
end

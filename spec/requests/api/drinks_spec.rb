# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::DrinksController, type: :request do
  let!(:user) { create(:user) }
  let!(:drinks) { create_list(:drink, 10, user: user) }

  describe '#GET /api/drinks' do
    it 'should request all drinks' do
      get api_drinks_path, headers: auth_header(user)
      expect(response).to have_http_status(200)
    end
  end

  describe '#GET /api/drinks/:id' do
    it 'should request drink by id' do
      get api_drink_path(drinks.sample.id), headers: auth_header(user)
      expect(response).to have_http_status(200)
    end
  end

  describe '#POST /api/drinks' do
    it 'should create a drink' do
      attributes = attributes_for(:drink).except(:user)
      post api_drinks_path, params: attributes.to_json, headers: auth_header(user)
      expect(response).to have_http_status(201)
    end
    it 'should throw error with invalid params' do
      post api_drinks_path, headers: auth_header(user)
      expect(response).to have_http_status(422)
    end
  end

  describe '#PUT /api/drinks/:id' do
    let!(:drink) { drinks.sample }
    it 'should update a drink' do
      drink.name = 'editado'
      put api_drink_path(drink.id), params: drink.to_json, headers: auth_header(user)
      expect(response).to have_http_status(200)
    end
    it 'should throw error with invalid params' do
      drink.name = ''
      put api_drink_path(drink.id), params: drink.to_json, headers: auth_header(user)
      expect(response).to have_http_status(422)
    end
  end

  describe '#DELETE /api/drinks/:id' do
    it 'should delete drink' do
      delete api_drink_path(drinks.sample.id), headers: auth_header(user)
      expect(response).to have_http_status(204)
    end
  end
end

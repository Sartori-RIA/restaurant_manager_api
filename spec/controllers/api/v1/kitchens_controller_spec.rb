# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::KitchensController, type: :request do
  before :all do
    @organization = create(:organization)
    @admin = @organization.user
    @kitchen = create(:user, :kitchen, organization: @organization)
    @orders = create_list(:order, 10, :with_dish, organization: @organization)
  end

  describe '#GET /api/kitchens' do
    it 'retrieveses all kitchen orders' do
      get api_v1_kitchens_path, headers: auth_header(@kitchen)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#PUT /api/kitchens/:id' do
    let!(:item) { @orders.sample.order_items.sample }

    it 'updates order' do
      put api_v1_kitchen_path(id: item.id), params: item.to_json, headers: auth_header(@kitchen)
      expect(response).to have_http_status(:ok)
    end
  end
end

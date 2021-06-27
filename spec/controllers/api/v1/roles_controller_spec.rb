# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RolesController, type: :request do
  let!(:super_admin) { create(:user, :super_admin) }
  let!(:organization) { create(:organization) }
  let!(:with_read_permission) { organization.user }
  let!(:cant_modify) do
    [
      create(:user, :admin),
      create(:user, :waiter),
      create(:user, :kitchen),
      create(:user, :cash_register),
      create(:user, :customer)
    ]
  end
  let!(:roles) { create_list(:role, 10) }

  describe '#GET /api/roles' do
    it 'requests all roles' do
      get api_v1_roles_path, headers: auth_header(super_admin)
      expect(response).to have_http_status(:ok)
    end

    it 'admin can read all roles' do
      get api_v1_roles_path, headers: auth_header(with_read_permission)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#GET /api/roles/:id' do
    it 'requests role by id' do
      get api_v1_role_path(roles.sample.id), headers: auth_header(super_admin)
      expect(response).to have_http_status(:ok)
    end

    it 'admin can read role by id' do
      get api_v1_roles_path, headers: auth_header(with_read_permission)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#POST /api/roles' do
    it 'creates a role' do
      attributes = attributes_for(:role)
      post api_v1_roles_path, params: attributes.to_json, headers: auth_header(super_admin)
      expect(response).to have_http_status(:created)
    end

    it 'throws error with invalid params' do
      post api_v1_roles_path, headers: auth_header(super_admin)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'with invalid permission, should return forbidden status' do
      attributes = attributes_for(:role)
      post api_v1_roles_path, params: attributes.to_json, headers: auth_header(cant_modify.sample)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe '#PUT /api/roles/:id' do
    let!(:role) { roles.sample }

    it 'updates a role' do
      role.name = 'editado'
      put api_v1_role_path(role.id), params: role.to_json, headers: auth_header(super_admin)
      expect(response).to have_http_status(:ok)
    end

    it 'throws error with invalid params' do
      role.name = ''
      put api_v1_role_path(role.id), params: role.to_json, headers: auth_header(super_admin)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'with invalid permission, should return forbidden status' do
      role.name = 'editado'
      put api_v1_role_path(role.id), params: role.to_json, headers: auth_header(cant_modify.sample)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe '#DELETE /api/roles/:id' do
    it 'deletes role' do
      delete api_v1_role_path(roles.sample.id), headers: auth_header(super_admin)
      expect(response).to have_http_status(:no_content)
    end

    it 'with invalid permission, should return forbidden status' do
      delete api_v1_role_path(roles.sample.id), headers: auth_header(cant_modify.sample)
      expect(response).to have_http_status(:forbidden)
    end
  end
end

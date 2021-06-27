# frozen_string_literal: true

json.extract! user,
              :id,
              :email,
              :name,
              :organization_id,
              :role,
              :role_id,
              :created_at,
              :updated_at

json.organization do
  json.partial! 'api/v1/organizations/organization', organization: user.organization
end

# frozen_string_literal: true

json.extract! food,
              :id,
              :name,
              :price_cents,
              :price_currency,
              :image,
              :quantity_stock,
              :valid_until,
              :created_at,
              :updated_at

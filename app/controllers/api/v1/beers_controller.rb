# frozen_string_literal: true

module Api
  class V1::BeersController < ApplicationController
    load_and_authorize_resource

    def index
      paginate json: @beers.order(name: :asc), include: %i[beer_style maker]
    end

    def show
      render json: @beer.to_json
    end

    def search
      @beers = Beer.search params[:q]
      paginate json: @beers.order(name: :asc), include: %i[beer_style maker]
    end

    def create
      @beer = Beer.new(create_params)

      if @beer.save
        render json: @beer.to_json, status: :created
      else
        render json: @beer.errors, status: :unprocessable_entity
      end
    end

    def update
      if @beer.update(update_params)
        render json: @beer.to_json
      else
        render json: @beer.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @beer.destroy
    end

    private

    def create_params
      update_params.merge(organization_id: current_user.organization_id)
    end

    def update_params
      params.permit(
        :name,
        :description,
        :image,
        :maker_id,
        :maker,
        :beer_style_id,
        :beer_style,
        :price,
        :ibu,
        :quantity_stock,
        :abv,
        :user_id,
        :id,
        :price_cents,
        :price_currency,
        :deleted_at,
        :created_at,
        :updated_at,
        :valid_until
      )
    end
  end
end
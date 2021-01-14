# frozen_string_literal: true

module Abilities
  class KitchenAbility < Abilities::BaseAbility
    def initialize(user:, controller_name:)
      super()
      can :manage, User, id: user.id
      return unless controller_name == 'Api::Kitchens'

      can :read, OrderItem,
          item_type: 'Dish',
          created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day,
          order: { organization_id: user.organization_id }
      can :update, OrderItem,
          order: {
            organization_id: user.organization_id
          }
    end
  end
end

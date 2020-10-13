# frozen_string_literal: true

class WineStyle < ApplicationRecord
  acts_as_paranoid

  validates :name, presence: true, uniqueness: true

  has_many :wines, dependent: :restrict_with_error
end

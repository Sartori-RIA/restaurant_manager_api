# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Allowlist

  acts_as_paranoid

  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :confirmable, :lockable, :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :name, :company_name, :cnpj, presence: true
  validates_cnpj_format_of :cnpj

  has_many :beer_styles, dependent: :delete_all
  has_many :beers, dependent: :delete_all
  has_many :makers, dependent: :delete_all
  has_many :drinks, dependent: :delete_all
  has_many :foods, dependent: :delete_all
  has_many :orders, dependent: :delete_all
  has_many :dishes, dependent: :delete_all
  has_many :tables, dependent: :delete_all

  has_one :theme, dependent: :delete

  after_create :set_default_theme

  def password_salt
    'no salt'
  end

  def password_salt=(new_salt) end

  def on_jwt_dispatch(token, payload)
    super
  end

  def send_reset_password_instructions; end

  def generate_code
    loop do
      code = ''
      6.times do
        code += (0..9).to_a.sample.to_s
      end
      break code unless User.find_by(reset_password_token: code)
    end
  end

  def send_welcome
    UserMailer.with(user: self).welcome.deliver_now!
  end

  protected

  def set_default_theme
    Theme.create(name: 'default',
                 color_footer: 'slate',
                 color_header: 'white',
                 color_sidebar: 'slate',
                 rtl: false,
                 user: self)
  end
end

class Merchant < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_reference, against: :reference

  has_many :orders

  validates :reference, :email, :live_on, :disbursement_frequency, :weekday, presence: true
end

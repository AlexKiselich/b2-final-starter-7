class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  enum discount: [:dollar, :percent]
  enum status: [:inactive, :active]
end

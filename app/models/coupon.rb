class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  enum status: [:deactivated, :activated]
end

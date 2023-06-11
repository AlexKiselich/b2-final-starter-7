class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  validates_presence_of  :name,
                        :discount,
                        :status,
                        :merchant_id

  validates :amount, numericality: { only_integer: true, greater_than: 0 }
  validates :code, uniqueness: { case_sensitive: false }



  enum discount: [:dollars, :percent]
  enum status: [:inactive, :active]


  def count
    invoices.joins(:transactions).where("transactions.result = 1").count
  end
end

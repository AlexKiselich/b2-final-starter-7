require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe "validations" do
    merchant = Merchant.create!(name: "merchant name inserted", status: 0)
    subject { Coupon.new(name: "Name inserted", amount: 0, discount: 0, merchant_id: merchant.id) }
    it { should validate_presence_of :name }
    it { should validate_presence_of :discount }
    it { should validate_presence_of :status }
    it { should validate_presence_of :merchant_id }
    it { should validate_numericality_of(:amount) }
    it { should validate_uniqueness_of(:code).case_insensitive}
  end
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoices }
  end
end

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
    it { should belong_to(:coupon).optional }
  end
  describe "instance methods" do
    it "#total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

    it "#grand_total" do
      @merchant1 = Merchant.create!(name: 'Hair Care')

      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant: @merchant1, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant: @merchant1)

      @coupon_1 = Coupon.create!(name: "10% Off", code: "10pO", amount: 10, discount: 1, status: 1, merchant: @merchant1)
      @coupon_2 = Coupon.create!(name: "$30 Off", code: "30dO", amount: 30, discount: 0, status: 1, merchant: @merchant1)

      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

      @invoice_1 = Invoice.create!(customer: @customer_1, status: 2, created_at: "2012-03-27 14:54:09", coupon: @coupon_1)
      @ii_1 = InvoiceItem.create!(invoice: @invoice_1, item: @item_1, quantity: 9, unit_price: 10, status: 2)
      @ii_2 = InvoiceItem.create!(invoice: @invoice_1, item: @item_8, quantity: 3, unit_price: 5, status: 2)
      @transaction1 = Transaction.create!(credit_card_number: 234237, result: 1, invoice: @invoice_1)

      @invoice_2 = Invoice.create!(customer: @customer_1, status: 2, created_at: "2012-03-27 14:54:09", coupon: @coupon_2 )
      @ii_3 = InvoiceItem.create!(invoice: @invoice_2, item: @item_1, quantity: 9, unit_price: 30, status: 2)
      @ii_4 = InvoiceItem.create!(invoice: @invoice_2, item: @item_8, quantity: 9, unit_price: 30, status: 2)
      @transaction2 = Transaction.create!(credit_card_number: 234232, result: 1, invoice: @invoice_2)

      @invoice_3 = Invoice.create!(customer: @customer_1, status: 2, created_at: "2012-03-27 14:54:09", coupon: @coupon_2 )
      @ii_5 = InvoiceItem.create!(invoice: @invoice_3, item: @item_1, quantity: 1, unit_price: 10, status: 2)
      @ii_6 = InvoiceItem.create!(invoice: @invoice_3, item: @item_8, quantity: 1, unit_price: 10, status: 2)
      @transaction2 = Transaction.create!(credit_card_number: 234232, result: 1, invoice: @invoice_2)


      expect(@invoice_1.grand_total).to eq(94.5)
      expect(@invoice_2.grand_total).to eq(510.0)
      expect(@invoice_3.grand_total).to eq(0)
    end
  end
end

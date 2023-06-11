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

  describe "instance methods" do
    before(:each) do
    @sau = Merchant.create!(name: "Stones Are Us")

    @sau10 = Coupon.create!(name: "$10 Off", code: "SAU10$", amount: 10, discount: 0, merchant: @sau)
    @sau20 = Coupon.create!(name: "20% Off", code: "SAU20%", amount: 20, discount: 1, merchant: @sau)
    @sau50 = Coupon.create!(name: "50% Off", code: "SAU50%", amount: 50, discount: 1, merchant: @sau)

    @customer_1 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_2 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_3 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @item_1 = Item.create!(name: "Stone", description: "Dope Stone", unit_price: 200, merchant: @sau)
    @item_2 = Item.create!(name: "Rock", description: "Nice Rocks", unit_price: 300, merchant: @sau)
    @item_3= Item.create!(name: "Pebbles", description: "Great Pebbles", unit_price: 100, merchant: @sau)

    @invoice_1 = Invoice.create!(customer: @customer_1, status: 2, coupon: @sau10)
    @invoice_2 = Invoice.create!(customer: @customer_1, status: 2, coupon: @sau10)
    @invoice_3 = Invoice.create!(customer: @customer_2, status: 2, coupon: @sau10)
    @invoice_4 = Invoice.create!(customer: @customer_2, status: 2, coupon: @sau10)
    @invoice_5 = Invoice.create!(customer: @customer_3, status: 2, coupon: @sau10)

    @ii_1 = InvoiceItem.create!(invoice: @invoice_1, item: @item_1, quantity: 9, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice: @invoice_2, item: @item_2, quantity: 1, unit_price: 10, status: 0)
    @ii_3 = InvoiceItem.create!(invoice: @invoice_3, item: @item_2, quantity: 2, unit_price: 8, status: 2)
    @ii_4 = InvoiceItem.create!(invoice: @invoice_4, item: @item_1, quantity: 3, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice: @invoice_5, item: @item_1, quantity: 3, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice: @invoice_1)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice: @invoice_2)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice: @invoice_3)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice: @invoice_4)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 0, invoice: @invoice_5) 
    end
    describe "#count" do
      it "Shows how many times a coupon had been used successfully" do
        expect(@sau10.count).to eq(4)
      end
    end
  end
end

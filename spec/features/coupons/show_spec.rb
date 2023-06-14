require "rails_helper"

RSpec.describe "Coupons Show Page" do
  before(:each) do
    @sau = Merchant.create!(name: "Stones Are Us")

    @sau10 = Coupon.create!(name: "$10 Off", code: "SAU10$", amount: 10, discount: 0, status: 1, merchant: @sau)
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

  it "displays the name, code, status and percentage/dollar off value of coupon" do
    visit merchant_coupon_path(@sau, @sau10)

    expect(page).to have_content(@sau10.name)
    expect(page).to have_content("Unique Code: #{@sau10.code}")
    expect(page).to have_content("Coupon's Status: #{@sau10.status}")
    expect(page).to have_content("Value: #{@sau10.amount} #{@sau10.discount} Off")
    expect(page).to_not have_content(@sau20)
  end

  it "diplays the count of how many times the coupon has been used" do
    visit merchant_coupon_path(@sau, @sau10)
    expect(page).to have_content("Used 4 Times")
  end

  it "displays a button to deactivate a coupon" do
    visit merchant_coupon_path(@sau, @sau10)

    within "#coupon-#{@sau10.id}" do
      expect(@sau10.status).to eq("active")
      expect(page).to have_content("Status: active")

      click_button "Deactivate Coupon"
    end

    expect(current_path).to eq(merchant_coupon_path(@sau, @sau10))
    expect(page).to have_content("Status: inactive")
  end

  it "displays a button to activate a coupon" do
    visit merchant_coupon_path(@sau, @sau20)

    within "#coupon-#{@sau20.id}" do
      expect(@sau20.status).to eq("inactive")
      expect(page).to have_content("Status: inactive")

      click_button "Activate Coupon"
    end

    expect(current_path).to eq(merchant_coupon_path(@sau, @sau20))
    expect(page).to have_content("Status: active")
  end

  it "displays error if merchant tries to activate more than 5 coupons" do
    @dau = Merchant.create!(name:"Doors Are Us")
    @coupon_1 = @dau.coupons.create!(name: "10% Off", code: "10-p-o", amount: 10, discount: 1, status: 1)
    @coupon_2 = @dau.coupons.create!(name: "20% Off", code: "20-p-o", amount: 20, discount: 1, status: 1)
    @coupon_3 = @dau.coupons.create!(name: "$10 Off", code: "10-d-o", amount: 10, discount: 0, status: 1)
    @coupon_4 = @dau.coupons.create!(name: "$20 Off", code: "20-d-o", amount: 20, discount: 0, status: 1)
    @coupon_5 = @dau.coupons.create!(name: "$30 Off", code: "30-d-o", amount: 30, discount: 0, status: 1)
    @coupon_6 = @dau.coupons.create!(name: "$25 Off", code: "25-d-o", amount: 20, discount: 0)


    visit merchant_coupon_path(@dau, @coupon_6)
    within "#coupon-#{@coupon_6.id}" do
      expect(@coupon_6.status).to eq("inactive")
      expect(@dau.coupons.active.count).to eq(5)
      expect(page).to have_button("Activate Coupon")
      click_button "Activate Coupon"
    end
    expect(current_path).to eq(merchant_coupons_path(@dau))
    expect(page).to have_content("Error: You cannot have more than 5 active coupons, please deactivate one first")
  end
end
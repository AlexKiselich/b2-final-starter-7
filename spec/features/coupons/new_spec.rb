require "rails_helper"

describe "Merchant Coupon New" do
  before :each do
    @sau = Merchant.create!(name: "Stones Are Us")
    @sau20 = Coupon.create!(name: "Rocks 20% Off", code: "SAU20%", amount: 20, discount: 1, merchant: @sau)
  end

  it "should be able to fill in a form and create a new coupon" do
    visit new_merchant_coupon_path(@sau)

    fill_in("Name", with: "Rocks 15% Off")
    fill_in("Code", with: "SAU15%")
    fill_in("Amount", with: 15)
    select "percent", from: "discount"

    click_button "Create Coupon"

    expect(current_path).to eq(merchant_coupons_path(@sau))
    expect(page).to have_content("Rocks 15% Off")
  end

  it "can't create a new coupon if the code is already created" do
    visit new_merchant_coupon_path(@sau)

    fill_in("Name", with: "Pebbles 20% Off")
    fill_in("Code", with: "SAU20%")
    fill_in("Amount", with: 20)
    select "percent", from: "discount"

    click_button "Create Coupon"

    expect(current_path).to eq(new_merchant_coupon_path(@sau))
    expect(page).to have_content("Code has already been taken")
  end
end

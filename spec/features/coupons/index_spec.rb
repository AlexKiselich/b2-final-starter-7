require "rails_helper"

RSpec.describe "Merchant Coupons Index Page" do
  before(:each) do
    @sau = Merchant.create!(name: "Stones Are Us")

    @sau10 = Coupon.create!(name: "$10 Off", code: "SAU10$", amount: 10, discount: 0, merchant: @sau)
    @sau20 = Coupon.create!(name: "20% Off", code: "SAU20%", amount: 20, discount: 1, merchant: @sau)
    @sau50 = Coupon.create!(name: "50% Off", code: "SAU50%", amount: 50, discount: 1, status: 1, merchant: @sau)

    @ww = Merchant.create!(name: "Wood Works")
    @ww20 = Coupon.create!(name: "20% Off", code: "WW20%", amount: 20, discount: 1, merchant: @ww)
  end

  it "displays all the names of my coupons including their amount off" do
    visit merchant_coupons_path(@sau)
    expect(page).to have_content("All My Coupons")

    within "#Coupon-#{@sau10.id}" do
      expect(page).to have_content(@sau10.name)
      expect(page).to have_content("Amount Off: #{@sau10.amount} #{@sau10.discount}")
    end

    within "#Coupon-#{@sau50.id}" do
      expect(page).to have_content(@sau50.name)
      expect(page).to have_content("Amount Off: #{@sau50.amount} #{@sau50.discount}")
    end
  end

  it "displays a link to each coupons show page using their name" do
    visit merchant_coupons_path(@ww)

    within "#Coupon-#{@ww20.id}" do
      expect(page).to have_link("#{@ww20.name}")
      expect(page).to have_content("Amount Off: #{@ww20.amount} #{@ww20.discount}")
    end
  end

  it "displays a link to create a new coupopn" do
    visit merchant_coupons_path(@sau)
    expect(page).to have_link("Create New Coupon")

    click_link "Create New Coupon"

    expect(current_path).to eq(new_merchant_coupon_path(@sau))
  end

  it "displays the coupons separated between active and inactive coupons" do
    visit merchant_coupons_path(@sau)

    expect(page).to have_content("Active Coupons:")

    within "#active" do
      expect(page).to have_content(@sau50.name)
      expect(page).to_not have_content(@sau10.name)
    end

    expect(page).to have_content("Inactive Coupons:")

    within "#inactive" do
      expect(page).to have_content(@sau10.name)
      expect(page).to have_content(@sau20.name)
      expect(page).to_not have_content(@sau50.name)
    end
  end
end
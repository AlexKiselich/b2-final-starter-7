class CouponsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    coupon = Coupon.new(new_coupon_params)
    if coupon.valid?
      coupon.save
      flash.notice = "New Coupon has been created!"
      redirect_to merchant_coupons_path(merchant)
    else
      redirect_to new_merchant_coupon_path(merchant)
      flash.notice =  "Error: #{coupon.errors.full_messages.to_sentence}"
    end
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  private

  def new_coupon_params
    params.permit(:name, :code, :amount, :discount, :merchant_id)
  end

end
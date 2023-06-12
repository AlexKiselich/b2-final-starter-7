# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
InvoiceItem.destroy_all
Transaction.destroy_all
Invoice.destroy_all
Coupon.destroy_all
Item.destroy_all
Customer.destroy_all
Merchant.destroy_all

Rake::Task["csv_load:all"].invoke

sau = Merchant.create!(name: "Stones Are Us")

sau10 = Coupon.create!(name: "$10 Off", code: "SAU10$", amount: 10, discount: 0, status: 1, merchant: sau)
sau20 = Coupon.create!(name: "20% Off", code: "SAU20%", amount: 20, discount: 1, merchant: sau)
sau50 = Coupon.create!(name: "50% Off", code: "SAU50%", amount: 50, discount: 1, merchant: sau)

customer_1 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
customer_2 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
customer_3 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

item_1 = Item.create!(name: "Stone", description: "Dope Stone", unit_price: 200, merchant: sau)
item_2 = Item.create!(name: "Rock", description: "Nice Rocks", unit_price: 300, merchant: sau)
item_3= Item.create!(name: "Pebbles", description: "Great Pebbles", unit_price: 100, merchant: sau)

invoice_1 = Invoice.create!(customer: customer_1, status: 2, coupon: sau10)
invoice_2 = Invoice.create!(customer: customer_1, status: 2, coupon: sau10)
invoice_3 = Invoice.create!(customer: customer_2, status: 2, coupon: sau10)
invoice_4 = Invoice.create!(customer: customer_2, status: 2, coupon: sau10)
invoice_5 = Invoice.create!(customer: customer_3, status: 2, coupon: sau10)

ii_1 = InvoiceItem.create!(invoice: invoice_1, item: item_1, quantity: 9, unit_price: 10, status: 0)
ii_2 = InvoiceItem.create!(invoice: invoice_2, item: item_2, quantity: 1, unit_price: 10, status: 0)
ii_3 = InvoiceItem.create!(invoice: invoice_3, item: item_2, quantity: 2, unit_price: 8, status: 2)
ii_4 = InvoiceItem.create!(invoice: invoice_4, item: item_1, quantity: 3, unit_price: 5, status: 1)
ii_5 = InvoiceItem.create!(invoice: invoice_5, item: item_1, quantity: 3, unit_price: 5, status: 1)

transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice: invoice_1)
transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice: invoice_2)
transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice: invoice_3)
transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice: invoice_4)
transaction5 = Transaction.create!(credit_card_number: 102938, result: 0, invoice: invoice_5)
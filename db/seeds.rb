# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'csv'

CSV.foreach('merchants.csv', headers: true, col_sep: ';') do |row|
  m = Merchant.create!(row.to_hash)
  m.update!(weekday: Date.parse(row['live_on']).wday)
end

CSV.foreach('orders.csv', headers: true, col_sep: ';') do |row|
  Order.create!(amount: row['amount'],
                merchant_id: Merchant.find_by_reference(row['merchant_reference'])&.id,
                reference_date: Date.parse(row['created_at']))
end

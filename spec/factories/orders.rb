FactoryBot.define do
  factory :order do
    amount { Faker::Number.decimal(l_digits: 2) }
    reference_date { Faker::Date.between(from: 1.year.ago, to: Date.today) }
    merchant
  end
end

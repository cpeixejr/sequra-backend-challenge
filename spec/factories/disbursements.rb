FactoryBot.define do
  factory :disbursement do
    amount { Faker::Number.decimal(l_digits: 2) }
    total_fee { Faker::Number.decimal(l_digits: 2) }
    reference_date { Faker::Date.between(from: 1.year.ago, to: Date.today) }
  end
end

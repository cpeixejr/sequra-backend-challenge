FactoryBot.define do
  factory :merchant do
    reference { Faker::Company.name.downcase.gsub('-', '_') }
    email { Faker::Internet.email }
    live_on { Faker::Date.between(from: 1.year.ago, to: Date.today) }
    weekday { live_on.wday }
    disbursement_frequency { Faker::Boolean.boolean ? 'DAILY' : 'WEEKLY' }
    minimum_monthly_fee { Faker::Number.decimal(l_digits: 2) }
  end
end

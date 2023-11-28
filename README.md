# README

This application was created to sequra backend coding challenge

- Ruby version: `3.2.2`
- Rails version: `7.1.2`

- System dependencies

- Configuration
  `bundle install`

- Database creation
  I used PostgreSQL
  `rake db:setup`
  The system takes a while to load around 1M `Order` records

- How to run the test suite
  `bundle exec rspec`

- Services (job queues, cache servers, search engines, etc.)
  We are using Sidekiq to job queues
  We are using Sidekiq-cron to perform daily disbursement process at 8:00 am UTC

# Technical choices

The framework chosen was Ruby on Rails. The solution has 3 models: `Order`, `Merchant`, and `Disbursement`.

- The `Merchant` `has_many` `Orders`
  Fields of `Merchant` table:

  - `id: uuid`
  - `reference: string`
  - `email: string`
  - `live_on: date`
  - `weekday: integer`
  - `disbursement_frequency: string`
  - `minimum_monthly_fee: float`
  - `created_at: datetime`
  - `updated_at: datetime`

- The `Disbursement` `has_many` `Orders`
  Fields of `Disbursement` table:

  - `id: uuid`
  - `amount: float`
  - `total_fee: float`
  - `reference_date: date`
  - `created_at: datetime`
  - `updated_at: datetime`

- The `Order` `belongs_to` `Merchant`
- The `Order` `belongs_to` `Disbursement` (optional)
  Fields of `Order` table:

  - `id: uuid`
  - `amount: float`
  - `merchant_id: uuid`
  - `reference_date: date`
  - `disbursement_id: uuid`
  - `created_at: datetime`
  - `updated_at: datetime`

All `ids` from models are UUID. The use of UUID allows you to merge rows from multiple databases or distribute databases across multiple servers. UUID values don't give out information about your data. Therefore it's safe to use in a URL.
But UUID values have more extensive storage needs than integers and because of their size and lack of order, UUID values may cause performance issues.

We are using the gem `sidekiq-cron` to process daily creation of disbursements. The model `Disbursement` has a class method named `create_process` that receives two arguments: `start_date` and `end_date`. The method iterates over all orders that weren't processed yet and are between the `start_date` and `end_date`. The method also excludes orders belongs to merchants that have `weekly` frequency and the week day is diferent from the `weekday` field of merchant (I store this value regarding the `live_on`).

Call `Disbursement.create_process(Date.new(2022, 1, 1), Date.new(2023, 12, 31))` inside a `rails console` to populate the `Disbursement` model.

After create all the disbursements, the Annual Report can be accessed by this URL: `http://localhost:3000/annual_report`

The list of disbursements with all related orders can be accessed from `http://localhost:3000/disbursements`.

To schedule the job, we can create a job through the `rails console`. Just run this command: `Sidekiq::Cron::Job.create(name: 'Disbursement Dayly Creation', cron: '0 8 * * * UTC', class: 'CreateDisbursementsDailyJob')`

The dashboard of this job can be accessed from `http://localhost:3000/sidekiq/cron`

# Improvements

Because of time constraints, I didn't implement this following business rule:

- Lastly, on the first disbursement of each month, we have to ensure the `minimum_monthly_fee` for the previous month was reached. The `minimum_monthly_fee` ensures that seQura earns at least a given amount for each merchant.

To finish this business logic we can code a method to check if it is the first disbursement fo the month to this specific merchant and reference_date. This method can be called inside the `create_process` of Disbursment

- Add more tests for jobs and requests.
- Add Authentication and Authorization to prevent unauthorized access.
- Use ENUMs for the `disbursement_frequency`

# Annual Report

| Year | Number of disbursements | Amount disbursed to merchants | Amount of order fees |
| ---- | ----------------------- | ----------------------------- | -------------------- |
| 2022 | 1.479                   | 36.503.551,59 €               | 329.610,22 €         |
| 2023 | 10.363                  | 187.980.199,24 €              | 1.703.961,96 €       |

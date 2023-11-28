class CreateDisbursementsDailyJob
  include Sidekiq::Job

  def perform(*_args)
    Disbursement.create_process(Date.today.prev_day, Date.today.prev_day)
  end
end

# Sidekiq::Cron::Job.create(name: 'Disbursement Dayly Creation', cron: '0 8 * * * UTC', class: 'CreateDisbursementsDailyJob') # execute at 8 a.m UTC daily

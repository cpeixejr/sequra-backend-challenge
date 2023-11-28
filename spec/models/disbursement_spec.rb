require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  it 'should create a valid disbursement' do
    disbursement = build(:disbursement)
    expect(disbursement).to be_valid
  end

  it 'should return nil if the create_proccess method is called with an end_date < start_date' do
    expect(Disbursement.create_process(Date.new(2023, 3, 1), Date.new(2021, 12, 31))).to be(nil)
  end
end

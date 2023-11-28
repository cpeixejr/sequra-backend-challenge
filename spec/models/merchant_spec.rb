require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it 'should create a valid merchant' do
    merchant = build(:merchant)
    expect(merchant).to be_valid
  end
end

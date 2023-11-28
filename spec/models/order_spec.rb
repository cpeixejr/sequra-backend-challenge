require 'rails_helper'

RSpec.describe Order, type: :model do
  it 'should caclulate correct taxes for each order' do
    # 1.00 % fee for orders with an amount strictly smaller than 50 €
    order1 = build(:order, amount: 49)
    expect(order1.calculate_tax).to be(0.01)

    # 0.95 % fee for orders with an amount between 50 € and 300 €.
    order2 = build(:order, amount: 50)
    expect(order2.calculate_tax).to be(0.0095)

    # 0.85 % fee for orders with an amount of 300 € or more.
    order3 = build(:order, amount: 300)
    expect(order3.calculate_tax).to be(0.0085)

    order4 = build(:order, amount: 1000)
    expect(order4.calculate_tax).to be(0.0085)
  end
end

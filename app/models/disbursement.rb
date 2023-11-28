class Disbursement < ApplicationRecord
  has_many :orders, dependent: :nullify

  default_scope { order(reference_date: :desc) }

  def self.is_the_first_of_month?(reference_date, merchant_id)
    Disbursement.joins(:orders).where(
      'extract(year from disbursements.reference_date) = ? AND extract(month from disbursements.reference_date) = ? AND merchant_id = ?', reference_date.year, reference_date.month, merchant_id
    ).size == 0
  end

  # Disbursements groups all the orders for a merchant in a given day or week.
  def self.create_process(start_date, end_date)
    return if end_date < start_date

    (start_date..end_date).each do |day|
      all_orders = Order.to_be_disbursed(day)
      amount_by_merchant = Hash.new(0)
      fees_by_merchant = Hash.new(0)

      all_orders.each do |order|
        fee = order.caclulate_fee
        fees_by_merchant[order.merchant_id] += fee
        amount_by_merchant[order.merchant_id] += (order.amount - fee)
      end

      amount_by_merchant.each do |merchant, total_amount|
        disbursement = Disbursement.create!(amount: total_amount, reference_date: day,
                                            total_fee: fees_by_merchant[merchant])
        all_orders.where(merchant_id: merchant).update_all(disbursement_id: disbursement.id)
      end
    end
  end
end

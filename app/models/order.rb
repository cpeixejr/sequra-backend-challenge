class Order < ApplicationRecord
  belongs_to :merchant
  belongs_to :disbursement, optional: true

  # 1.00 % fee for orders with an amount strictly smaller than 50 €
  # 0.95 % fee for orders with an amount between 50 € and 300 €.
  # 0.85 % fee for orders with an amount of 300 € or more.

  FIRST_RANGE = 50
  SECOND_RANGE = 300
  FIRST_TAX_RANGE = 0.01
  SECOND_TAX_RANGE = 0.0095
  THIRD_TAX_RANGE = 0.0085

  scope :to_be_disbursed, lambda { |reference_date|
                            joins(:merchant)
                              .where('disbursement_id IS NULL AND reference_date <= ?', reference_date)
                              .where('disbursement_frequency = ? OR (disbursement_frequency = ? AND extract(dow from date ?) = weekday)',
                                     'DAILY', 'WEEKLY', reference_date)
                          }

  def calculate_tax
    if amount < FIRST_RANGE
      FIRST_TAX_RANGE
    else
      (amount < SECOND_RANGE ? SECOND_TAX_RANGE : THIRD_TAX_RANGE)
    end
  end

  def caclulate_fee
    (amount * calculate_tax).round(2)
  end
end

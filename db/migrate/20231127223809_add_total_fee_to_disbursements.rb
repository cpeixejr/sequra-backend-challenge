class AddTotalFeeToDisbursements < ActiveRecord::Migration[7.1]
  def change
    add_column :disbursements, :total_fee, :float
  end
end

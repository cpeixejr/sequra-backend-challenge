class AddDisbursementsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :disbursement_id, :uuid
    add_index :orders, :disbursement_id
  end
end

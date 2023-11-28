class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders, id: :uuid do |t|
      t.float :amount
      t.uuid :merchant_id
      t.date :reference_date
      t.timestamps
    end

    add_index :orders, :merchant_id
  end
end

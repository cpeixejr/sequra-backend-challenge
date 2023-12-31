class CreateMerchants < ActiveRecord::Migration[7.1]
  def change
    create_table :merchants, id: :uuid do |t|
      t.string :reference
      t.string :email
      t.date :live_on
      t.integer :weekday
      t.string :disbursement_frequency
      t.float :minimum_monthly_fee
      t.timestamps
    end
  end
end

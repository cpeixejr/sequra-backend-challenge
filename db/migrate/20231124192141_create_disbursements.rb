class CreateDisbursements < ActiveRecord::Migration[7.1]
  def change
    create_table :disbursements, id: :uuid do |t|
      t.float :tax
      t.float :fee
      t.float :amount
      t.date :reference_date

      t.timestamps
    end
  end
end

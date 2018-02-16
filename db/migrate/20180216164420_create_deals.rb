class CreateDeals < ActiveRecord::Migration[5.1]
  def change
    create_table :deals do |t|
      t.references :portfolio, foreign_key: true
      t.references :stock, foreign_key: true
      t.decimal :amount

      t.timestamps
    end
  end
end

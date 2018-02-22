class AddInvestmentToPortfolios < ActiveRecord::Migration[5.1]
  def change
    add_column :portfolios, :investment, :decimal
  end
end

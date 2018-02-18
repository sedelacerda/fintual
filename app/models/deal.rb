class Deal < ApplicationRecord
  belongs_to :portfolio
  belongs_to :stock

  def trx_type
    self.is_sale? ? 'Sale' : 'Buy'
  end
end

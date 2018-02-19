class Deal < ApplicationRecord
  belongs_to :portfolio
  belongs_to :stock

  after_save :set_amount_sign

  def trx_type
    self.is_sale? ? 'Sale' : 'Buy'
  end

  def set_amount_sign
    if self.is_sale? and self.amount > 0
      self.amount = -self.amount.abs
      self.save!
    elsif !self.is_sale? and self.amount < 0
      self.amount = self.amount.abs
      self.save!
    end
  end
end

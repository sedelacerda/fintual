class Deal < ApplicationRecord
  belongs_to :portfolio
  belongs_to :stock

  before_create :set_amount_sign, :count_on_investment

  def trx_type
    self.is_sale? ? 'Sell' : 'Buy'
  end

  def set_amount_sign
    if self.is_sale? and self.amount > 0
      self.amount = -self.amount.abs
    elsif !self.is_sale? and self.amount < 0
      self.amount = self.amount.abs
    end
  end

  def count_on_investment
    p = self.portfolio

    if self.is_sale?
      p.investment += (self.amount * self.stock.price(self.created_at)).abs
      p.save!
    else
      new_investment = self.portfolio.investment - (self.amount * self.stock.price(self.created_at)).abs

      if new_investment > 0
        p.investment = new_investment
        p.save!
      else
        raise "You only have #{p.investment} left"
      end
    end
  end
end

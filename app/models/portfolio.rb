class Portfolio < ApplicationRecord
    has_many :deals
    has_many :stocks, through: :deals
    before_create :set_investment
    
    def first_trx_date
        if self.deals.empty?
            nil
        else
            self.deals.order(:created_at).first.created_at
        end
    end

    def stocks_at(datetime_end)
        start_date = self.first_trx_date

        if self.first_trx_date.nil?
            []
        else
            output = []
            lapse_deals = self.deals.where(created_at: start_date..datetime_end)
            lapse_deals.group(:stock).sum(:amount).each do |s, n|
                if n > 0
                    output << [s, n]
                end
            end
            output
        end
    end

    def investment_at(datetime)
        deals_after = self.deals.where("created_at > ?", datetime)
        amount_after = 0

        deals_after.each do |d|
            amount_after += d.amount * d.stock.price(d.created_at)
        end

        self.investment + amount_after
    end

    def capital_at(datetime)
        stocks_amount = self.stocks_at(datetime)
        capital = 0.0

        stocks_amount.each do |s, n|
            capital += n*s.price(datetime)
        end

        (capital + self.investment_at(datetime)).round(2)
    end

    def stocks_value_at(datetime)
        capital_at(datetime) - investment_at(datetime)
    end

    def profit(datetime_start=nil, datetime_end=nil)
        if self.deals.empty?
            0
        else
            if !(datetime_start.present? and datetime_end.present?)
                datetime_start = self.deals.order(:created_at).first.created_at.beginning_of_day
                datetime_end = DateTime.now
            end

            if datetime_end.to_date == Date.today
                datetime_end = DateTime.now
            end

            profit = self.capital_at(datetime_end) - self.capital_at(datetime_start)

            profit

        end

    end


    private
        def set_investment
            if self.investment.nil?
                self.investment = (rand*500000).round(2)
            end
        end
end

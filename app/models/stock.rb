class Stock < ApplicationRecord

    def price(date_time=DateTime.now)
        stock_base = 0
        self.name.each_byte{|b| stock_base += b}
        stock_base = stock_base % 80000.00
        date_time_base = date_time.to_time.to_i % 20.00

        ('%.2f' % ((stock_base + date_time_base)/100.00)).to_d
    end
end

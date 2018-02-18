class Stock < ApplicationRecord

    def price(date_time=DateTime.now)
        stock_base = 0
        self.name.each_byte{|b| stock_base += b}
        stock_base = stock_base % 80000.0
        date_time_base = date_time.to_time.to_i % 20.0

        ap stock_base
        ap date_time_base
        (stock_base + date_time_base)/10.00
    end
end

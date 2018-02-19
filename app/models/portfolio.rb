class Portfolio < ApplicationRecord
    has_many :deals
    has_many :stocks, through: :deals
    
    
    # Ingresos: 
    #     - Venta de acciones
    #     - Ganancias por rentabilidad de acciones
    #     - 
    # Costos:
    #     - Compra de acciones
    #     - Perdidas por reduccion en precio de acciones

    # Patrimonio inicial = numero de acciones compradas * precio de compra de accion

    # Ingresos/perdidas = (dif. precio compra-actual acciones actuales)
    #                     + (dif. inversion-ventas)
    

    def investment
        inv = 0
        self.deals.each do |deal|
            if !deal.is_sale
                inv += deal.amount * deal.stock.price(deal.created_at)
            end
        end
        inv
    end

    # - 150 * 1000
    # +  50 * 2000
    # + 100 * 2100





    

    # def sold_stocks_profit(datetime_start=nil, datetime_end=nil)
    #     if self.deals.empty?
    #         0
    #     else
    #         if !(datetime_start.present? and datetime_end.present?)
    #             datetime_start = self.deals.order(:created_at).first.created_at
    #             datetime_end = DateTime.now
    #         end

    #         lapse_deals = self.deals.where(created_at: datetime_start..datetime_end)

    #         sold_deals = lapse_deals.group(:stock).having("SUM(amount) = 0").count
    #         profit = 0

    #         sold_deals.each do |stock, c|
    #             lapse_deals.where(stock: stock).each do |deal|
    #                 profit += deal.amount * deal.stock.price(deal.created_at)
    #             end
    #         end

    #         profit

    #     end
    # end

    def profit(datetime_start=nil, datetime_end=nil)
        # Ingresos - Gastos
        if self.deals.empty?
            0
        else
            if !(datetime_start.present? and datetime_end.present?)
                datetime_start = self.deals.order(:created_at).first.created_at
                datetime_end = DateTime.now
            end

            lapse_deals = self.deals.where(created_at: datetime_start..datetime_end)
            profit = 0

            # Diferencia inversion-ventas

            lapse_deals.each do |deal|
                profit += deal.amount * deal.stock.price(deal.created_at)
            end

            current_stocks = lapse_deals.group(:stock).having("SUM(amount) > 0").sum(:amount)

            current_stocks.each do |stock, qty|
                profit += qty * stock.price(datetime_end)
            end

            profit


            # lapse_deals = self.deals.where(created_at: datetime_start..datetime_end)

            # lapse_deals.each do |deal|
            #     profit += deal.is_sale? ? (deal.amount * deal.stock.price(deal.created_at)) : -(deal.amount * deal.stock.price(deal.created_at))
            # end

            # profit - self.investment

        end

    end
end

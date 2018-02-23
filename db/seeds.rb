# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def rand_in_range(from, to)
    rand * (to - from) + from
end

def rand_time(from, to=Time.now)
    Time.at(rand_in_range(from.to_f, to.to_f))
end


# Stocks
40.times do
    s = Stock.create!(name: Faker::Company.unique.name)
    ap s
end

# Portfolios
5.times do |i|
    p = Portfolio.create!(name: 'Portfolio ' + (i+1).to_s)
    ap p
end

Portfolio.all.each do |p|
    10.times do
        d = Deal.create!(portfolio: p, stock: Stock.all.sample, amount: (rand*15.0).round(2), is_sale: false, created_at: rand_time(3.years.ago))
        ap d
    end
end
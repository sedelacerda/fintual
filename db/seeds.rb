# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Stocks
40.times do
    s = Stock.create!(name: Faker::Company.unique.name)
    ap s
end

# Portfolios
5.times do |i|
    p = Portfolio.create!(name: 'Portfolio ' + i.to_s)
    ap p
end
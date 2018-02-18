class Portfolio < ApplicationRecord
    has_many :deals
    has_many :stocks, through: :deals
end

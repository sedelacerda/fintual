class AddIsSaleToDeals < ActiveRecord::Migration[5.1]
  def change
    add_column :deals, :is_sale, :boolean, default: false
  end
end

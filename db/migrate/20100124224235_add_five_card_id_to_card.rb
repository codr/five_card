class AddFiveCardIdToCard < ActiveRecord::Migration
  def self.up
    add_column :cards, :five_card_id, :integer
  end

  def self.down
    remove_column :cards, :five_card_id
  end
end

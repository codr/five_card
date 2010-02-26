class CreateFiveCards < ActiveRecord::Migration
  def self.up
    create_table :five_cards do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :five_cards
  end
end

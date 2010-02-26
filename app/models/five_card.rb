class FiveCard < ActiveRecord::Base
  has_many :cards, :autosave => true, :dependent => :destroy
  
  def isHigher?(otherFiveCard)
    Hand.new(cards).isHigher?(Hand.new(otherFiveCard.cards))
  end
end

class Deck < Array
  
  
  SUITS = ['S', 'C', 'D', 'H']
  RANKS = (2..14).to_a
  
  def initialize
    SUITS.each { |suit| 
      RANKS.each { |rank| 
        self << Card.new(:rank => rank, :suit => suit)
      }
    }
  end
  
  def shuffle!  
  	each_index do |i| 
  	  j = Kernel.rand(length-i) + i
      self[j], self[i] = self[i], self[j]  
	  end
  end
  
  def takeOne
    pop
  end
  
  def deal5Cards
    hand = Hand.new
    5.times do
      hand << pop
    end
    hand
  end
  
end
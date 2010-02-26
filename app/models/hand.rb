class Hand < Array
  
  RANKS = (0..8).to_a # => 0 is high card
                      # => 1 is one pair
                      # => 2 is two pairs
                      # => 3 is three of a kind
                      # => 4 is straight
                      # => 5 is flush
                      # => 6 is full house
                      # => 7 is four of a kind
                      # => 8 is straight flush
  
  def << card
    super
    sort!{ |x,y | y.rank.to_i <=> x.rank.to_i }
  end
  
  
  def isHigher?(otherHand)
    if rank == otherHand.rank then
      subRank > otherHand.subRank
    else
      rank > otherHand.rank
    end
  end
  
  def rank
    return 8 if straightFlush?
    return 7 if fourOfAKind?
    return 6 if fullHouse?
    return 5 if flush?
    return 4 if straight?
    return 3 if threeOfAKind?
    return 2 if twoPair?
    return 1 if pair?
    return 0 # => High Card
  end
  
  def subRank
    count = 0
    case rank
    when 8 # straight flush
        Hand.new(flush).straightRank
    when 7 # four of a kind
      highestQuadsValue * 100 + (self - highestQuadsValue).map{|c| c.rank.to_i}.max
    when 6 # full house
      fullHouse.map{|card| card.rank.to_i}.uniq.each do |value|
        count = count * 100 + value
      end
      count
    when 5 # flush
      flush.map{|card| card.rank.to_i}.each do |value|
        count = count * 100 + value
      end
      count
    when 4 # straight
      straightRank
    when 3 # three of a kind
      count = highestTripsValue
      (self - threeOfAKind)[0..1].each do |card|
        count = count * 100 + card.rank.to_i
      end
      count
    when 2 # two pair
      twoPair.map{|card| card.rank.to_i}.uniq.each do |value|
        count = count * 100 + value
      end
      count = count * 100 + (self - twoPair).first.rank.to_i
    when 1 # one pair
      count = highestPairValue
      (self - pair)[0..2].each do |card|
        count = count * 100 + card.rank.to_i
      end
      count
    when 0 # high card
      map{ |card| if card.rank.to_i == 1 then 14 else card.rank.to_i end }.sort.reverse[0..4].each do |value|
        count = count * 100 + value
      end
      count
    else
      raise Error
    end
    
  end
  
  def to_s
    to_sentence
  end
  
  def straightFlush? # => assumes only 5 cards in hand
    Hand.new(flush).straight? if flush?
  end
  
  def straightFlush
    
  end
  
  def fourOfAKind?
    numberSameRank.max >= 4
  end
  
  def fourOfAKind
    select{|card| card.rank.to_i == highestQuadsValue }[0..3]
  end
  
  def fullHouse?# => TODO: borken: 3 of a kinds is also a pair. so every 3of a kind will be a Full House
    if threeOfAKind?
      (numberSameRank - numberSameRank.find{|c| c >= 3 }.to_a).max >= 2
    else
      false
    end
  end
  
  def fullHouse
    Hand.new(threeOfAKind + Hand.new(self - threeOfAKind).pair) if fullHouse?
  end
    
  def flush?        # => 5 cards to a flush
    groupSuits.map{|suit| suit.length}.max >=5
  end
  
  def flush
    groupSuits.select{|suit| suit.length >= 5} # might be possible to have 2 flushes? if so this is wong
  end
  
  def straight?
    straightRank != false
  end
  
  def straightRank  # => returns false if not a straight or the high card of the stright (14 is Ace)
    ranks = map{ |card| card.rank.to_i }.uniq.sort
    return false unless ranks.select{|rank| rank.to_i == 10 or rank.to_i == 5} # need 5 or 10 for a straight
    ranks.reverse!
    ranks.push 1 if ranks.first.to_i == 14     # => Ace is hight or low
    highCardIndex = (0..ranks.length-4).map do |index|
      ranks[index].to_i - 4 == ranks[index+4]
    end.index(true)
    
    return false unless highCardIndex
    ranks[highCardIndex]
  end
  
  def threeOfAKind?
    numberSameRank.max >= 3
  end
  
  def threeOfAKind
    select{|card| card.rank.to_i == highestTripsValue }[0..2]
  end
  
  def twoPair?
    numberSameRank.select{|count| count >= 2 }.length >= 2
  end
  
  def twoPair
    Hand.new(pair + Hand.new(self - pair).pair) if twoPair?
  end
  
  def pair?
    numberSameRank.max >=2
  end
  
  def pair
    select{ |card| card.rank.to_i == highestPairValue }[0..1]
  end
  
#private

  def numberSameRank # => return an array[13] of number of that value [4,0,0,...] is 4 Aces
    ((2..14).to_a).map do |value|
      select {|card| card.rank.to_i == value}.length
    end.reverse
  end

  def orderRank
    Hand.new sort_by { |card|
      unless card.rank == 1 then      # => make exception for ace. Turn 1 into 14
        card.rank 
      else 
        14
      end
    }.reverse
  end
  
  def groupSuits
    Deck::SUITS.map do |suit|
      select { |card| card.suit == suit }
    end
  end
  
  def highestPairValue
    highestValueInGroup 2
  end
  
  def highestTripsValue
    highestValueInGroup 3
  end
  
  def highestQuadsValue
    highestValueInGroup 4
  end
  
  def highestValueInGroup(num)
    14 - numberSameRank.index(numberSameRank.find{|c| c >= num })
  end
  
end
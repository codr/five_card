module FiveCardHelper
  
  SUIT_TO_INT = {  "C" => 0,
                    "S" => 1,
                    "H" => 2,
                    "D" => 3}
  CARD_HEIGHT = 98
  CARD_WIDTH  = 73
  
  def displayCard card
    "<div style=\"background-image:url('/images/classic-playing-cards.png');" + 
    'margin:2px;' +
    'width:74px;' +
    'height:98px;' +
    "background-position:" + 
      "-#{(card.rank.to_i - 1) * CARD_WIDTH }px " +
      "-#{SUIT_TO_INT[card.suit] * CARD_HEIGHT }px;" +
    "\"></div>"
  end
  
end
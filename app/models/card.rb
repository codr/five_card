class Card < ActiveRecord::Base
  
  belongs_to :five_card

  def to_s
    "#{rank}-#{suit}"
  end

end
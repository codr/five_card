class FiveCardController < ApplicationController
  # GET /five_cards
  # GET /five_cards.xml
  no_login_required
  
#  radiant_layout 'Normal'
  
  def index
    @five_cards = FiveCard.all.reverse #FiveCard.find(:first, :order => "created_on DESC" )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @five_cards }
    end
  end

  # GET /five_cards/new
  # GET /five_cards/new.xml
  def new
    
    @highest_hand = FiveCard.find(:first, :order => "created_at DESC" )
    
    cards = Deck.new.shuffle!.deal5Cards
    @test_hand = FiveCard.new(:cards => cards)
    
    if !@highest_hand
      @highest_hand = @test_hand
      @highest_hand.save
    end
    
    if @test_hand.isHigher?(@highest_hand) then
      @test_hand.save
      @won = true
    else
      @won = false
    end

    respond_to do |format|
      format.html
      format.xml  { render :xml => @five_card }
    end
  end

  # GET /five_cards/1/edit
  def edit
    @five_card = FiveCard.find(params[:id])
  end

  # POST /five_cards
  # POST /five_cards.xml
  def create
    @five_card = FiveCard.new(params[:five_card])

    respond_to do |format|
      if @five_card.save
        flash[:notice] = 'FiveCard was successfully created.'
        format.html { redirect_to(@five_card) }
        format.xml  { render :xml => @five_card, :status => :created, :location => @five_card }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @five_card.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /five_cards/1
  # DELETE /five_cards/1.xml
  def destroy
    @five_card = FiveCard.find(params[:id])
    @five_card.destroy

    respond_to do |format|
      format.html { redirect_to(five_card_url) }
      format.xml  { head :ok }
    end
  end
end

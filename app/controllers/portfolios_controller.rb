class PortfoliosController < ApplicationController

  before_action :set_portfolio_item, only: [:edit, :show, :update, :destroy]
  layout 'portfolio'
  access all: [:show, :index, :angular], user: {except: [:destroy, :new, :create, :update, :edit]}, site_admin: :all

  def index
    @portfolio_items = Portfolio.by_position
  end

  def sort
    params[:order].each do |key, value|
      Portfolio.find(value[:id]).update(position: value[:position])
    end

    render nothing: true
  end


  def angular
    @angular_portfolio_items = Portfolio.angular
  end
  
  def new
    @portfolio = Portfolio.new
 
  end

  def create
    @portfolio = Portfolio.new(portfolio_params)

    respond_to do |format|
      if @portfolio.save
        format.html { redirect_to portfolios_path, notice: 'Portfolio item was successfully created.' }
        format.json { render :show, status: :created, location: @portfolio }
      else
        format.html { render :new }
        format.json { render json: @portfolio.errors, status: :unprocessable_entity }

      end
    end
  end

  def edit
  end

  def update
    
    respond_to do |format|
      if @portfolio.update(portfolio_params)
        format.html { redirect_to portfolio_show_path(@portfolio) , notice: 'Portfolio was successfully updated.' }        
      else
        format.html { render :edit }    
      end
    end
  end

  def show   
  end

  def destroy
    @portfolio.destroy

    #Redirect
    respond_to do |format|
      format.html { redirect_to portfolios_url, notice: 'Portfolio was successfully destroyed.' }
      
    end
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(:title, 
                                      :subtitle, :body, 
                                      technologies_attributes: [:name])
  end

  def set_portfolio_item
     @portfolio = Portfolio.find(params[:id])
   end

end
  


class PortfoliosController < ApplicationController
  before_action :set_portfolio_item, only: [:edit, :update, :show, :destroy]

  layout "portfolio"

  access all: [:show, :index, :react], user: {except: [:destroy, :new, :create, :update, :edit]}, site_admin: :all


  def index
    @portfolio_items = Portfolio.all
  end

  def react
    @react_portfolio_items = Portfolio.react
  end

  def new
    @portfolio_item = Portfolio.new
  end

  def create
    @portfolio_item = Portfolio.new(portfolio_params)
      if @portfolio_item.save
        notice = "Your portfolio item is now live."
        redirect_to portfolios_path, notice: notice
      else
        render :new 
      end
  end

  def edit
  end

  def update  
    if @portfolio_item.update(portfolio_params)
      notice = 'The record successfully updated.'
      redirect_to portfolios_path, notice: notice
    else
      render :edit 
    end
  end

  def show
  end

  def destroy
   @portfolio_item.destroy
   notice = "Record was removed."
   redirect_to portfolios_url, notice: notice 
  end

  private

    def portfolio_params 
      params.require(:portfolio).permit(:title, 
                                        :subtitle, 
                                        :body,
                                        :main_image,
                                        :thumb_image,
                                        technologies_attributes: [:id, :name, :_destroy])
    end

    def set_portfolio_item
      @portfolio_item = Portfolio.find(params[:id])
    end
end

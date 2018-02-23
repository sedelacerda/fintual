class PortfoliosController < ApplicationController
  protect_from_forgery with: :exception, except: :profit_by_year
  before_action :set_portfolio, only: [:show, :edit, :update, :destroy]

  # GET /portfolios
  # GET /portfolios.json
  def index
    @portfolios = Portfolio.all.order(:name)
  end

  def update_profit
    @portfolio = Portfolio.find(params[:portfolio_id])
    start = params[:start_date].to_date.beginning_of_day
    finish = params[:finish_date].to_date.end_of_day

    profit = @portfolio.profit(start, finish)
    init_capital = @portfolio.capital_at(start)
    # profit_percentage = init_capital > 0 ? ((profit/init_capital) * 100) : 0

    @result = "#{profit.round(2)}"

    respond_to do |format|
      format.js
    end
  end

  def profit_by_year
    @portfolio = Portfolio.find(params[:portfolio_id])
    @finish_date = Date.today.strftime("%d/%m/%Y")
    @start_date = @portfolio.deals.empty? ? @finish_date : @portfolio.deals.order(:created_at).first.created_at.strftime("%d/%m/%Y") 
  end

  def profit_by_year_chart
    start_date = params[:start_date].to_date.beginning_of_day
    finish_date = params[:finish_date].to_date.end_of_day
    
    @portfolio = Portfolio.find(params[:portfolio_id])
    portfolio_deals = @portfolio.deals

    @years = (start_date.year..finish_date.year).to_a
    @data = []

    @years.each do |year|
      init_of_year = "1/1/#{year}".to_date.beginning_of_year
      finish_of_year = "1/1/#{year}".to_date.end_of_year

      start = init_of_year < start_date ? start_date : init_of_year
      finish = finish_date < finish_of_year ? finish_date : finish_of_year

      @data << @portfolio.profit(start, finish).to_f.round(2)
    end

    ap @years
    ap @data

    respond_to do |format|
      format.js
    end
  end

  # GET /portfolios/1
  # GET /portfolios/1.json
  def show
    @finish_date = Date.today.strftime("%d/%m/%Y")
    @start_date = @portfolio.deals.empty? ? @finish_date : @portfolio.deals.order(:created_at).first.created_at.strftime("%d/%m/%Y")
    @portfolio_stock_amount = @portfolio.deals.having("SUM(amount) > 0").group(:stock).sum(:amount)
  end

  # GET /portfolios/new
  def new
    @portfolio = Portfolio.new
  end

  # GET /portfolios/1/edit
  def edit
  end

  # POST /portfolios
  # POST /portfolios.json
  def create
    @portfolio = Portfolio.new(portfolio_params)

    respond_to do |format|
      if @portfolio.save
        format.html { redirect_to @portfolio, notice: 'Portfolio was successfully created.' }
        format.json { render :show, status: :created, location: @portfolio }
      else
        format.html { render :new }
        format.json { render json: @portfolio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /portfolios/1
  # PATCH/PUT /portfolios/1.json
  def update
    respond_to do |format|
      if @portfolio.update(portfolio_params)
        format.html { redirect_to @portfolio, notice: 'Portfolio was successfully updated.' }
        format.json { render :show, status: :ok, location: @portfolio }
      else
        format.html { render :edit }
        format.json { render json: @portfolio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /portfolios/1
  # DELETE /portfolios/1.json
  def destroy
    @portfolio.destroy
    respond_to do |format|
      format.html { redirect_to portfolios_url, notice: 'Portfolio was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_portfolio
      @portfolio = Portfolio.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def portfolio_params
      params.require(:portfolio).permit(:name)
    end
end

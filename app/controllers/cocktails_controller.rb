class CocktailsController < ApplicationController
  def index
    @tags = Cocktail.distinct(:category).pluck(:category)
    if params[:query]
      @cocktails = Cocktail.where("category LIKE ?", "%#{params[:query]}%")
    elsif params[:ingredient] && params[:ingredient] != ""
      @cocktails = Cocktail.joins(doses: :ingredient).where("ingredients.name LIKE ?", "%#{params[:ingredient]}%")
      @cocktails = Cocktail.all if @cocktails.empty?
    else
      @cocktails = Cocktail.order(:name)
    end
    @cocktails_sample = []
    3.times do
      @cocktails_sample << @cocktails.sample
    end
  end

  def show
    @cocktail = Cocktail.find(params[:id])
    @dose = Dose.new
  end

  def new
    @cocktail = Cocktail.new
  end

  def create
    @cocktail = Cocktail.new(cocktail_params)
    if @cocktail.save
      redirect_to cocktail_path(@cocktail)
    else
      render :new
    end
  end

  def destroy
    @cocktail = Cocktail.find(params[:id])
    @cocktail.destroy
    redirect_to cocktails_path
  end

  private

  def cocktail_params
    params.require(:cocktail).permit(:name, :description, :image_url)
  end
end

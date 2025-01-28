class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
    @ingredients = Ingredient.all
  end

  def create
    @recipe = Recipe.new(recipe_params)

    if @recipe.save
      params[:recipe][:ingredient_ids].each_with_index do |ingredient_id, index|
        if ingredient_id.present?
          @recipe.recipe_ingredients.create(ingredient_id: ingredient_id, quantity: params[:recipe][:ingredient_quantities][index])
        end
      end

      redirect_to @recipe, notice: "Przepis został utworzony."
    else
      @ingredients = Ingredient.all
      render :new
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
    @ingredients = Ingredient.all
  end

  def update
    @recipe = Recipe.find(params[:id])

    if @recipe.update(recipe_params)
      @recipe.recipe_ingredients.destroy_all

      params[:recipe][:ingredient_ids].each_with_index do |ingredient_id, index|
        if ingredient_id.present?
          @recipe.recipe_ingredients.create(ingredient_id: ingredient_id, quantity: params[:recipe][:ingredient_quantities][index])
        end
      end

      redirect_to @recipe, notice: "Przepis został zaktualizowany."
    else
      @ingredients = Ingredient.all
      render :edit
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy

    redirect_to recipes_url, notice: "Przepis został usunięty."
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :instructions)
  end
end
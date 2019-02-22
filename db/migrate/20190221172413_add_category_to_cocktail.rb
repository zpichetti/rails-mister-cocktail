class AddCategoryToCocktail < ActiveRecord::Migration[5.2]
  def change
    add_column :cocktails, :category, :string
  end
end

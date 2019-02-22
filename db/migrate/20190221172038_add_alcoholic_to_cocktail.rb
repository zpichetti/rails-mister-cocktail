class AddAlcoholicToCocktail < ActiveRecord::Migration[5.2]
  def change
    add_column :cocktails, :alcoholic, :string
  end
end

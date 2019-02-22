require "json"
require "rest-client"


def dose(det, cocktail)
  ingredient = []
  doses = []
  i = 1
  15.times do
    ingredient << det["strIngredient#{i}"]
    doses << det["strMeasure#{i}"]
    i += 1
  end
  ingredient.delete("")
  ingredient.each_with_index do |ing, index|
    ingredient_base = Ingredient.find_by(name: ing)
    puts "add #{ing} at #{cocktail.name}"
    doses[index]
    doses[index] == "\n" || doses[index] == " " || doses[index] == "" ? desc = "-" : desc = doses[index]
    dose = Dose.new(description: desc, ingredient: ingredient_base)
    dose.cocktail = cocktail
    dose.save if dose.ingredient
  end
end

puts 'Cleaning dose database...'
Dose.destroy_all

puts 'Cleaning indredient database...'
Ingredient.destroy_all

puts 'Creating indredient...'
response = RestClient.get "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"
ingredients = JSON.parse(response)
ingredients['drinks'].each do |ingredient|
  puts "add #{ingredient['strIngredient1']}"
  Ingredient.create!(name: ingredient['strIngredient1'])
end

puts 'Cleaning cocktail database...'
Cocktail.destroy_all

puts 'Creating Alcoholic cocktail ...'
response = RestClient.get "https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Alcoholic"
cocktails = JSON.parse(response)
cocktails['drinks'].each do |cocktail|
  resp = RestClient.get "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{cocktail['idDrink']}"
  cocktail_det = JSON.parse(resp)
  cocktail_det['drinks'].each do |det|
    cock = Cocktail.new
    puts det['strDrink']
    cock.name = det['strDrink']
    cock.description = det['strInstructions']
    cock.image_url = det['strDrinkThumb']
    cock.alcoholic = det['strAlcoholic']
    cock.glass = det['strGlass']
    cock.category = det['strCategory']
    cock.save!
    dose(det, cock)
  end
end

puts 'Creating Non Alcoholic cocktail ...'
response = RestClient.get "https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Non_Alcoholic"
cocktails = JSON.parse(response)
cocktails['drinks'].each do |cocktail|
  resp = RestClient.get "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{cocktail['idDrink']}"
  cocktail_det = JSON.parse(resp)
  cocktail_det['drinks'].each do |det|
    cock = Cocktail.new
    puts det['strDrink']
    cock.name = det['strDrink']
    cock.description = det['strInstructions']
    cock.image_url = det['strDrinkThumb']
    cock.alcoholic = det['strAlcoholic']
    cock.glass = det['strGlass']
    cock.category = det['strCategory']
    cock.save!
    dose(det, cock)
  end
end




puts 'Finished!'

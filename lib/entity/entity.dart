import '../client/client.dart';

class Recipe {
  final int id;
  final String title;

  Recipe({required this.id, required this.title});

  factory Recipe.fromRecipeResponse(
    Result response,
  ) {
    return Recipe(id: response.id, title: response.title);
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title
    };
  }
}

class Ingredient {
  final String name;
  final String image;
  final String amount;

  Ingredient({required this.name, required this.image, required this.amount});

  factory Ingredient.fromIngredientResponse(
      IngredientResponse ingredientResponse) {
    return Ingredient(
      name: ingredientResponse.name,
      image: ingredientResponse.image,
      amount:
          '${ingredientResponse.amount.value} ${ingredientResponse.amount.unit}',
    );
  }
}

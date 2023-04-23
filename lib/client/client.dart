import 'package:http/http.dart' as http;
import 'dart:convert';
class SpoonacularClient {
  String _API_KEY = "c407ca99b022425db7a92c700d521f3e"; // apiKey
  Map<String, dynamic> parseJson(String jsonString) {
    return json.decode(jsonString);
  }
  String toJson(Map<String, dynamic> jsonObject) {
    return json.encode(jsonObject);
  }
  Future<RecipeResponse> searchRecipes(String query) async {
    final url = Uri.parse(
        "https://api.spoonacular.com/recipes/complexSearch?apiKey=$_API_KEY&=$query&number=10");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = parseJson(response.body);
      RecipeResponse recipeResponse = RecipeResponse.fromJson(jsonResponse);
      return recipeResponse;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
  Future<List<IngredientResponse>> getIngredients(int recipeId) async {
    final url = Uri.parse(
        'https://api.spoonacular.com/recipes/$recipeId/ingredientWidget.json?apiKey=$_API_KEY');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body)['ingredients'];
      List<IngredientResponse> ingredients = jsonResponse
          .map((ingredientJson) => IngredientResponse.fromJson(
              ingredientJson as Map<String, dynamic>))
          .toList();
      return ingredients;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
class IngredientResponse {
  final String name;
  final String image;
  final Amount amount;
  IngredientResponse(
      {required this.name, required this.image, required this.amount});
  factory IngredientResponse.fromJson(Map<String, dynamic> json) {
    return IngredientResponse(
      name: json['name'],
      image: json['image'],
      amount: Amount.fromJson(json['amount']['metric']),
    );
  }
}
class Amount {
  final double value;
  final String unit;
  Amount({required this.value, required this.unit});
  factory Amount.fromJson(Map<String, dynamic> json) {
    return Amount(
      value: json['value'].toDouble(),
      unit: json['unit'],
    );
  }
}
class RecipeResponse {
  final List<Result> results;
  RecipeResponse({required this.results});
  factory RecipeResponse.fromJson(Map<String, dynamic> json) {
    return RecipeResponse(
        results: (json['results'] as List<dynamic>)
            .map((item) => Result.fromJson(item as Map<String, dynamic>))
            .toList());
  }
}
class Result {
  final int id;
  final String title;
  Result({required this.id, required this.title});
  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['id'],
      title: json['title'],
    );
  }
}

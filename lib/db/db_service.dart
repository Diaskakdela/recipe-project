import '../entity/entity.dart';
import 'package:firebase_database/firebase_database.dart';
import '../entity/entity.dart';


abstract class DatabaseService {
  Future<void> saveRecipe(Recipe recipe);
  Future<List<Recipe>> getSavedRecipes();
}

class PostgresDBService extends DatabaseService{
  @override
  Future<List<Recipe>> getSavedRecipes() {
    // TODO: implement getSavedRecipes
    throw UnimplementedError();
  }

  @override
  Future<void> saveRecipe(Recipe recipe) {
    // TODO: implement saveRecipe
    throw UnimplementedError();
  }
}

class FirebaseDBService extends DatabaseService {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  @override
  Future<List<Recipe>> getSavedRecipes() async {
    final dataSnapshot = await _firebaseDatabase.ref('recipes').once();
    List<Recipe> recipes = [];

    if (dataSnapshot.snapshot.value != null) {
      for (var entry in dataSnapshot.snapshot.children) {
        Map<String, dynamic> recipeData = (entry.value as Map<Object?, Object?>).cast<String, dynamic>();
        recipes.add(Recipe.fromJson(recipeData));
      }
    }
    return recipes;
  }


  @override
  Future<void> saveRecipe(Recipe recipe) async {
    Map<String, dynamic> rec = recipe.toJson();
    await _firebaseDatabase.ref('recipes').push().set(rec);
  }
}

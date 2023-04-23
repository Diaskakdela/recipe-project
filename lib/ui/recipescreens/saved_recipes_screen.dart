import 'package:flutter/material.dart';
import '../../client/client.dart';
import '../../db/db_service.dart';
import '../../entity/entity.dart';


class SavedRecipesScreen extends StatefulWidget {
  final DatabaseService databaseService;

  SavedRecipesScreen({required this.databaseService});

  @override
  _SavedRecipesScreenState createState() => _SavedRecipesScreenState();
}

class _SavedRecipesScreenState extends State<SavedRecipesScreen> {
  late Future<List<Recipe>> _savedRecipes;

  @override
  void initState() {
    super.initState();
    _savedRecipes = widget.databaseService.getSavedRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Recipes'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: _savedRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final recipes = snapshot.data!;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return ListTile(
                  title: Text(recipe.title),
                  onTap: () async {
                    try {
                      List<IngredientResponse> ingredients =
                      await SpoonacularClient().getIngredients(recipe.id);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(recipe.title),
                            content: Column(
                              children: ingredients
                                  .map((ingredientResponse) =>
                                  Ingredient.fromIngredientResponse(
                                      ingredientResponse))
                                  .map((ingredient) => Text(
                                  '${ingredient.name} - ${ingredient.amount}'))
                                  .toList(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Close'),
                              ),
                              TextButton(
                                onPressed: () {
                                  widget.databaseService.saveRecipe(recipe);
                                  Navigator.pop(context);
                                },
                                child: Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $error')),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

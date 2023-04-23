import 'package:flutter/material.dart';
import '../../client/client.dart';
import '../../db/db_service.dart';
import '../../entity/entity.dart';

class SearchRecipesScreen extends StatefulWidget {
  final SpoonacularClient spoonacularClient;
  final DatabaseService databaseService;

  SearchRecipesScreen(
      {required this.spoonacularClient, required this.databaseService});

  @override
  _SearchRecipesScreenState createState() => _SearchRecipesScreenState();
}

class _SearchRecipesScreenState extends State<SearchRecipesScreen> {
  String query = '';
  Future<RecipeResponse>? _recipeResponseFuture;

  void _onSearchButtonPressed() {
    setState(() {
      _recipeResponseFuture = widget.spoonacularClient.searchRecipes(query);
    });
  }

  void _onRecipeTapped(BuildContext context, Result recipe) async {
    List<IngredientResponse> ingredients =
        await widget.spoonacularClient.getIngredients(recipe.id);
    List<Ingredient> ingredientList = ingredients
        .map((ingredientResponse) =>
            Ingredient.fromIngredientResponse(ingredientResponse))
        .toList();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            children: [
              Text(recipe.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('Ingredients',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: ingredientList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Ingredient ingredient = ingredientList[index];
                    return ListTile(
                      title: Text('${ingredient.name} ${ingredient.amount} '),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Recipe newRecipe = Recipe.fromRecipeResponse(recipe);
                      await widget.databaseService.saveRecipe(newRecipe);
                      Navigator.pop(context);
                    },
                    child: Text('Save Recipe'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Recipes'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => query = value,
              decoration: InputDecoration(
                hintText: 'Enter a keyword',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _onSearchButtonPressed,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<RecipeResponse>(
                future: _recipeResponseFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.results.length,
                      itemBuilder: (BuildContext context, int index) {
                        Result recipe = snapshot.data!.results[index];
                        return ListTile(
                          title: Text(recipe.title),
                          onTap: () => _onRecipeTapped(context, recipe),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No recipes found'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

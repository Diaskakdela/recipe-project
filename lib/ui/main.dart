import 'package:flutter/material.dart';
import 'package:labproject/client/client.dart';
import 'package:labproject/db/db_service.dart';
import 'package:labproject/ui/recipescreens/saved_recipes_screen.dart';
import 'package:labproject/ui/recipescreens/search_recipes_screen.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());}

class MyApp extends StatelessWidget {

  SpoonacularClient spoonacularClient = new SpoonacularClient();
  DatabaseService databaseService = new FirebaseDBService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Рецепты',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Рецепты'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.search), text: 'Поиск рецептов'),
                Tab(icon: Icon(Icons.favorite), text: 'Сохраненные рецепты'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SearchRecipesScreen(spoonacularClient: spoonacularClient, databaseService: databaseService,),
              SavedRecipesScreen(databaseService: databaseService,),
            ],
          ),
        ),
      ),
    );
  }
}
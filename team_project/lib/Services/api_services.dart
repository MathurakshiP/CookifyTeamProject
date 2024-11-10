
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:team_project/model/meal_plan_model.dart';
import 'package:team_project/model/recipe_model.dart';

class ApiServices {
  ApiServices._instantiate();
  static final ApiServices instance = ApiServices._instantiate();

  final String baseURL ="https://api.spoonacular.com";
  static const String API_KEY ="1f75b517cba74599aea9b389c2fd4013";
  
  Future<MealPlan> generateMealPlan({
    required int targetCalories, 
    required String diet
    }) async{

      if(diet=="None") diet ='';
      Map<String, String> parameters ={
        'timeFrame': 'day',
        'targetCalories': targetCalories.toString(),
        'diet':diet,
        'apiKey':API_KEY,
      };

      Uri uri =Uri.https(
        baseURL,
        '/recipes/mealplans/generate',
        parameters,
      );

      Map<String,String> headers={
        HttpHeaders.contentTypeHeader:'application/json',
      };

      try{
        var response = await http.get(uri, headers: headers);
        Map<String,dynamic>data =json.decode(response.body);
        MealPlan mealPlan= MealPlan.fromMap(data);
        return mealPlan;
      }catch(err){
        throw err.toString();
      }
    }

    Future<Recipe> fetchRecipe(String id) async{
      Map<String,String> parameters = {
        'includeNutrition':'false',
        'apiKey':API_KEY,
      };

      Uri uri =Uri.https(
        baseURL,
        '/recipes/$id/information',
        parameters,
      );

      Map<String,String> headers={
        HttpHeaders.contentTypeHeader:'application/json',
      };

      try{
        var response = await http.get(uri, headers: headers);
        Map<String,dynamic>data =json.decode(response.body);
        Recipe recipe= Recipe.fromMap(data);
        return recipe;
      }catch(err){
        throw err.toString();
      }

    }
}
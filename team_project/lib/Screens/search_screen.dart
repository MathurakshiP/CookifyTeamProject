
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget{


  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>{

  List<String> _diets = [
    'None',
    'Gluten Free',
    'Ketogenic',
    'Lacto-Vegetarian',
    'Ovo-Vegetarian',
    'Vegan',
    'Pescetarian',
    'Palco',
    'Primal',
    'Whole30',

  ];

  double _targetCalories =2250;
  String _diet ='None';

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        image: DecorationImage(
          image: NetworkImage('https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.foodiesfeed.com%2F&psig=AOvVaw3TPGFK_Mve5ExxzPdLCV_V&ust=1731346790621000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCPDE48Sn0okDFQAAAAAdAAAAABAE')
          fit: BoxFit.cover,
        )

        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30) ,
            padding: EdgeInsets.symmetric(horizontal: 30),
            height: MediaQuery.of(context).size.height * 0.55 ,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),

            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'My Daily Meal Planner',
                  style: TextStyle(fontSize: 32),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ),

      )

    );
  }
}
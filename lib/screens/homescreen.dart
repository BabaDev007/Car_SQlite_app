import 'package:eval/utils/DbHelper.dart';
import 'package:eval/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../models/Car.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DbHelper = DatabaseHelper.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey  = GlobalKey<ScaffoldState>();

 var _carNameController = TextEditingController();

 var _carMilesController = TextEditingController();

  var _queryController = TextEditingController();


  List<Car> cars = [];

  @override
  Widget build(BuildContext context) {

    void _showMessageInScaffold(String s) {
      // _scaffoldKey.currentState!.((context) => Center(child: Text(s)));
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(s, style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),), behavior: SnackBarBehavior.floating,));
    }
    void _insert(String name, int miles)async {
      Map<String,dynamic> row = {
        DatabaseHelper.columnName : name,
        DatabaseHelper.columnMiles : miles
      };
      Car car  = Car.fromMap(row);
      final id = await DbHelper.insert(car);
      _showMessageInScaffold('inserted row id : $id');

    }
    return DefaultTabController(
      length: tabBar.length,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Car SQlite app "),
          bottom:TabBar(tabs: tabBar,),
        ) ,
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TFWidget(function: (){}, hint: "Car Name", controller:_carNameController, input: TextInputType.text, ),
                TFWidget(function: (){}, hint: "Car Miles", controller:_carMilesController, input: TextInputType.number ),
                ButtonWidget(function: (){
                  String name = _carNameController.text;
                  int miles = int.parse(_carMilesController.text);
                  _insert(name, miles);

                }, text: "Insert data")
              ],
            ),

            ListView.builder(
              padding: EdgeInsets.all(8),
                itemCount: cars.length + 1,
                itemBuilder: (BuildContext context, int index){
                if(index == cars.length) {
                  return ElevatedButton(
                      onPressed: () {
                        queryAll();
                        _showMessageInScaffold("Query done");
                        setState(() {

                        });
                      },
                      child: Text("Refresh"));
                }
                return Container(
                  height: 40,
                  child: Center(
                    child: Text('${cars[index].id} - ${cars[index].name} - ${cars[index].miles}', style: Theme.of(context).textTheme.headline5,),
                  ),
                );
              }),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TFWidget(function: (){}, hint: "Id", controller: _queryController, input: TextInputType.number)
                ],
              ),
            )

          ]

        )
      ),
    );


  }

  var tabBar = [
    Tab(text: "Insert",),
    Tab(text: "View",),
    Tab(text: "Query",),
    Tab(text: "Update",),
    Tab(text: "Delete",),
  ];

  void queryAll()async {
    final allRows = await DbHelper.queryAllRows();
    cars.clear();
    allRows.forEach((row) => cars.add(Car.fromMap(row)));
  }
}


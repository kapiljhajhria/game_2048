import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GridView.count(
        
        padding: EdgeInsets.all(8.0),
        crossAxisCount: 4,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: <Widget>[
          Container( child: Center(child: Text("0",style: TextStyle(color: Colors.black),))),
          Container( child: Center(child: Text("0",style: TextStyle(color: Colors.black),))),
          Container( child: Center(child: Text("0",style: TextStyle(color: Colors.black),))),
          Container( child: Center(child: Text("0",style: TextStyle(color: Colors.black),))),
          Container( child: Center(child: Text("0",style: TextStyle(color: Colors.black),))),
          Container( child: Center(child: Text("0",style: TextStyle(color: Colors.black),))),
          Container( child: Center(child: Text("0",style: TextStyle(color: Colors.black),))),
          Container( child: Center(child: Text("0",style: TextStyle(color: Colors.black),))),
          Container( child: Center(child: Text("0",style: TextStyle(color: Colors.black),))),
          Container( child: Center(child: Text("0",style: TextStyle(color: Colors.black),))),
          Container( child: Center(child: Text("0",style: TextStyle(color: Colors.black),))),
          Container( child: Center(child: Text("0",style: TextStyle(color: Colors.black),))),
          Container( child: Center(child: Text("0",style: TextStyle(color: Colors.black),))),
          Container( child: Center(child: Text("0",style: TextStyle(color: Colors.black),))),
          Container( child: Center(child: Text("0",style: TextStyle(color: Colors.black),))),
          Container( child: Center(child: Text("0",style: TextStyle(color: Colors.black),))),
        ],
      ),
    );
  }
}


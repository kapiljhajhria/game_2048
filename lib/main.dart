import 'package:flutter/material.dart';
import 'package:game_2048/game_logic.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Game2048 game=Game2048();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("2048"),),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 400,
            child: GridView.count(

              padding: EdgeInsets.all(8.0),
              crossAxisCount: 4,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              children: <Widget>[
                Container( child: Center(child: Text(game.board[0][0].toString(),style: TextStyle(color: Colors.black),))),
                Container( child: Center(child: Text(game.board[0][1].toString(),style: TextStyle(color: Colors.black),))),
                Container( child: Center(child: Text(game.board[0][2].toString(),style: TextStyle(color: Colors.black),))),
                Container( child: Center(child: Text(game.board[0][3].toString(),style: TextStyle(color: Colors.black),))),
                Container( child: Center(child: Text(game.board[1][0].toString(),style: TextStyle(color: Colors.black),))),
                Container( child: Center(child: Text(game.board[1][1].toString(),style: TextStyle(color: Colors.black),))),
                Container( child: Center(child: Text(game.board[1][2].toString(),style: TextStyle(color: Colors.black),))),
                Container( child: Center(child: Text(game.board[1][3].toString(),style: TextStyle(color: Colors.black),))),
                Container( child: Center(child: Text(game.board[2][0].toString(),style: TextStyle(color: Colors.black),))),
                Container( child: Center(child: Text(game.board[2][1].toString(),style: TextStyle(color: Colors.black),))),
                Container( child: Center(child: Text(game.board[2][2].toString(),style: TextStyle(color: Colors.black),))),
                Container( child: Center(child: Text(game.board[2][3].toString(),style: TextStyle(color: Colors.black),))),
                Container( child: Center(child: Text(game.board[3][0].toString(),style: TextStyle(color: Colors.black),))),
                Container( child: Center(child: Text(game.board[3][1].toString(),style: TextStyle(color: Colors.black),))),
                Container( child: Center(child: Text(game.board[3][2].toString(),style: TextStyle(color: Colors.black),))),
                Container( child: Center(child: Text(game.board[3][3].toString(),style: TextStyle(color: Colors.black),))),



              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            IconButton(icon: Icon(Icons.keyboard_arrow_left),onPressed: (){
              game.board=game.leftMoveBoard(game.board);
              game.board=game.addTwo2(game.board);
              print(game.board);
                setState(() {

                });
            },),
            IconButton(icon: Icon(Icons.keyboard_arrow_up),onPressed: (){
              game.board=game.slideUp(game.board);
              game.board=game.addTwo2(game.board);
              print(game.board);
              setState(() {

              });
            },),
            IconButton(icon: Icon(Icons.keyboard_arrow_down),onPressed: (){
              game.board=game.slideDown(game.board);
              game.board=game.addTwo2(game.board);
              print(game.board);
              setState(() {

              });
            },),
            IconButton(icon: Icon(Icons.arrow_right),onPressed: (){
              game.board=game.rightMoveBoard(game.board);
              game.board=game.addTwo2(game.board);
              print(game.board);
              setState(() {

              });
            },),
          ],)
        ],
      ),
    );
  }
}


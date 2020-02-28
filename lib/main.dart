import 'package:flutter/cupertino.dart';
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
      title: '2048',
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
  Game2048 game = Game2048();

  Widget singleCell(int num) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 1000),

      margin: EdgeInsets.all(5),
//        height: 80,
//        width: 80,
        decoration: new BoxDecoration(
          backgroundBlendMode: BlendMode.color,
          color: Colors.white,
          border: new Border.all(
              color: ColorTween(
                begin: Color(0xFFFBC02D),
                end: Color(0xff57BB8A), //FFD666
              ).transform((num / 68).toDouble()),
              width: 5.0,
              style: BorderStyle.solid),
        ),
        child: Center(
            child: Text(
          num.toString(),
          style: TextStyle(
              fontSize: 35, color: Colors.black, fontWeight: FontWeight.bold),
        )));
  }

  List<Widget> cellsGrid(List<List<int>> board) {
    List<Widget> temp = [];
    for (int i = 0; i < board.length; i++) {
      List<Widget> tempRow = [];
      for (int j = 0; j < board[i].length; j++) {
        tempRow.add(Expanded(child: singleCell(board[i][j])));
      }
      temp.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: tempRow,
      ));
    }
    return temp;
  }

  @override
  void initState() {
    // TODO: implement initState
    game.start();
    setState(() {});
  }

  Future<void> displayDialog({String message}) async {
    switch (await showDialog(
        barrierDismissible: false,

        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              message,
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  game.start();
                  setState(() {

                  });
                  Navigator.pop(context);
                },
                child: Text('OK'),
              )
            ],
          );
        })) {
    }
  }

  showPopUp() {
    if (game.gameStatus == Status.over) displayDialog(message: "Game Over");
    if (game.gameStatus == Status.won) displayDialog(message: "You Won");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("2048"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: GestureDetector(
              onHorizontalDragEnd: (drag) {
                if (drag.primaryVelocity > 0) {
                  print("swipe right");
                  game.slide((){game.slideRight(game.board);});
                }
                if (drag.primaryVelocity < 0) {
                  print("swipe left");
                  game.slide((){game.slideLeft(game.board);});
                }
                showPopUp();
                setState(() {});
              },
              onVerticalDragEnd: (drag) {
                if (drag.primaryVelocity > 0) {
                  print("swipe Down");
                  game.slide((){game.slideDown(game.board);});
                }
                if (drag.primaryVelocity < 0) {
                  print("swipe up");
                  game.slide((){game.slideUp(game.board);});
                }
                showPopUp();
                setState(() {});
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.white30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: cellsGrid(game.board),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin:EdgeInsets.all(10),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        backgroundBlendMode: BlendMode.color,
                        color: Colors.white,
                        border: Border.all(
                            color: ColorTween(
                              begin: Color(0xFF11C01E),
                              end: Color(0xffC00008), //FFD666
                            ).transform((game.moves/520).toDouble()),
                            width: 5.0,
                            style: BorderStyle.solid),
                      ),
                        alignment: Alignment.center,
                      child: Text("${game.moves}",style: TextStyle(fontSize: 20),),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    size: 50,
                  ),
                  onPressed: () {
                    game.start();
                    setState(() {});
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

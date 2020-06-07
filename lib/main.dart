import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_2048/game_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Game2048 game = Game2048();
  AnimationController myController;
  List<Widget> cellsList = [];
  Offset offsetStart = Offset(-3.0, 0.0);
  Offset offsetEnd = Offset(-3.0, 0.0);
  SharedPreferences prefs;

  List<Widget> cellsGrid(List<List<int>> board) {
    List<Widget> temp = [];
    for (int i = 0; i < board.length; i++) {
      List<Widget> tempRow = [];
      for (int j = 0; j < board[i].length; j++) {
        tempRow.add(Expanded(
            child: SingleCell(
          cellValue: board[i][j].toString(),
          controller: myController,
          offsetEnd: offsetEnd,
          offsetStart: offsetStart,
        )));
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
    getPrefsData();
    myController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    game.start();
  }

  void getPrefsData() async {
    await SharedPreferences.getInstance().then((sp) {
      prefs = sp;
      setState(() {});
    });
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
                    myController.forward();
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
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        title: Text("2048"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: GestureDetector(
              onHorizontalDragEnd: (drag) async {
                if (drag.primaryVelocity > 0) {
                  offsetEnd = Offset(4.0, 0.0);
                  offsetStart = Offset(-4.0, 0.0);
                  setState(() {});
                  game.slide(game.slideRight);
                  myController.forward(from: 0.0);
//                  myController.reset();
                  print("swipe right");

                  setState(() {});
                }
                if (drag.primaryVelocity < 0) {
                  offsetEnd = Offset(-4.0, 0.0);
                  offsetStart = Offset(4.0, 0.0);

                  setState(() {});
                  game.slide(game.slideLeft);
                  myController.forward(from: 0.0);
                  print("swipe left");
                }
                showPopUp();
                setState(() {});
              },
              onVerticalDragEnd: (drag) async {
                if (drag.primaryVelocity > 0) {
                  offsetEnd = Offset(0.0, 1.2);
                  offsetStart = Offset(0.0, -1.2);
                  setState(() {});
                  game.slide(game.slideDown);
                  myController.forward(from: 0.0).then((f) {});
                  print("swipe Down");
                }
                if (drag.primaryVelocity < 0) {
                  offsetEnd = Offset(0.0, -1.2);
                  offsetStart = Offset(0.0, 1.2);
                  setState(() {});
                  game.slide(game.slideUp);
                  myController.forward(from: 0.0).then((f) {
//                    myController.reset();
                  });
                  print("swipe up");
                }
                showPopUp();
                setState(() {});
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: cellsGrid(game.board),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                        color: ColorTween(
                          begin: Color(0xFF11C01E),
                          end: Color(0xffC00008), //FFD666
                        ).transform((game.moves / 520).toDouble()),
                        width: 5.0,
                        style: BorderStyle.solid),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${game.moves}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    size: 50,
                  ),
                  onPressed: () async {
                    offsetStart = Offset(-3.0, 0.0);
                    offsetEnd = Offset(-3.0, 0.0);
                    game.start();
                    setState(() {});
                    await myController.forward(from: 0.0).then((f) {
                      myController.reset();
                    });
                    print("reset");

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

class SingleCell extends StatefulWidget {
  String cellValue;
  Animation controller;
  Offset offsetEnd;
  Offset offsetStart;
  SingleCell(
      {this.cellValue, this.controller, this.offsetEnd, this.offsetStart});
  @override
  _SingleCellState createState() => _SingleCellState();
}

class _SingleCellState extends State<SingleCell> {
  String prevNum;

  @override
  void initState() {
    prevNum = widget.cellValue;
    setState(() {});
    widget.controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        prevNum = widget.cellValue;
      }
    });
    // TODO: implement initState
//
//    fadeAnimation = Tween(begin: 1.0, end: 0.0).animate(widget.controller);
//    fadeAnimationP = Tween(end: 1.0, begin: 0.0).animate(widget.controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        decoration: new BoxDecoration(
          ///TODO: write a function which takes in integer value and return Color
          color: ColorTween(
            begin: Color(0xFFFBC02D),
            end: Color(0xff57BB8A), //FFD666
          ).transform((int.parse(widget.cellValue) / 256).toDouble()),
          border: new Border.all(
              color: ColorTween(
                begin: Color(0xFFFBC02D),
                end: Color(0xff57BB8A), //FFD666
              ).transform((int.parse(widget.cellValue) / 12).toDouble()),
              width: 5.0,
              style: BorderStyle.solid),
        ),
        child: ClipRect(
          child: Center(
              child: Stack(
            children: <Widget>[
              SlideTransition(
                position: Tween<Offset>(
                  end: Offset.zero,
                  begin: widget.offsetStart,
                ).animate(CurvedAnimation(
                  parent: widget.controller,
                  curve: Curves.linear,
                )),
                child: Text(
                  widget.cellValue,
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SlideTransition(
                position: Tween<Offset>(
                  end: widget.offsetEnd,
                  begin: Offset(0.0, 0.0),
                ).animate(CurvedAnimation(
                  parent: widget.controller,
                  curve: Curves.linear,
                )),
                child: Text(
                  prevNum,
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )),
        ));
  }
}

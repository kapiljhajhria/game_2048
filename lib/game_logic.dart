// Write a function called play game which starts with empty (all 0s) 4 by 4 matrix and just one 2 at random place
// User should be able to play using the console
// l - left slide
// r - right slide
// d - up slide
// u - down slide
// With every move a 2 is added randomly into matrix

// Win - When any of the cell becomes 2048 user wins the game
// Game over - When all tiles (cells) are filled and no 2048 then game over
import 'dart:io';

import 'dart:math';

class Game2048 {
  List<List<int>> board = [
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
  ];
  Status gameStatus;
  int moves=0;

  List<int> leftSlide(List<int> numList) {
    int origSize = numList.length;
    numList = numList.where((a) => a != 0).toList(); //to filter out all zero
    var size = numList.length;
    for (int i = 0; i < size - 1; i++) {
      if (numList[i] == numList[i + 1]) {
        numList = removeElements(numList, i, i + 1);
        numList.add(0); //add zero in the end
        size--; //decrease size by 1, since we have replaced two items with 1
      }
    }
    int fillRemainingArray = origSize - numList.length;
    for (var j = 0; j < fillRemainingArray; j++) {
      numList.add(0);
    }
    // console.log(numList);
    return numList;
  }

  List<int> removeElements(List<int> nums, int i, int j) {
    int temp = nums[i] + nums[j];
    List<int> tempA = [];
    tempA.addAll(nums.sublist(0, i));
    tempA.add(temp);
    List<int> tempB = [];
    tempB.addAll(nums.sublist(j + 1));

    tempA.addAll(tempB);
    return tempA;
  }

  List<int> rightSlide(List<int> numList) {
    return leftSlide(numList.reversed.toList()).reversed.toList();
  }

  List<List<int>> transpose(List<List<int>> matrix) {
    int n = matrix.length;
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) // only the upper is iterated
      {
        swap(matrix, [i, j], [j, i]);
      }
    }
    return matrix;
  }

  List swap(List matrix, List a, List b) {
    int buffer = matrix[a[0]][a[1]];
    matrix[a[0]][a[1]] = matrix[b[0]][b[1]];
    matrix[b[0]][b[1]] = buffer;
    return matrix;
  }


  List<List<int>> slideLeft(List<List<int>> board) {
    for (var i = 0; i < board.length; i++) {
      board[i] = leftSlide(board[i]);
    }
    return board;
  }

  List<List<int>> slideRight(List<List<int>> board) {
    for (var i = 0; i < board.length; i++) {
      board[i] = rightSlide(board[i]);
    }
    return board;
  }

  List<List<int>> slideUp(board) {
    return (transpose(slideLeft(transpose(board))));
  }
// console.log(slideUp(board));

  List<List<int>> slideDown(board) {
    return transpose(slideRight(transpose(board)));
  }
// console.log(slideDown(board));

   String getNextMove() {
    String move;
    move = stdin.readLineSync();
    return move;
  }


  bool gameWon(board) {
    for (var row = 0; row < board.length; row++) {
      for (var col = 0; col < board[row].length; col++) {
        if (board[row][col] == 2048) {
          gameStatus = Status.won;
          return true;
        }
      }
    }
    gameStatus = Status.running;
    return false;
  }

  void updateGameStatus() {
    for (var row = 0; row < board.length; row++) {
      for (var col = 0; col < board[row].length; col++) {
        if (board[row][col] == 2048) {
          gameStatus = Status.won;
          return;
        } else if (board[row][col] == 0) {
          gameStatus = Status.running;
          return;
        } else if (col < board[row].length - 1 &&
            (board[row][col] == board[row][col + 1])) {
          gameStatus = Status.running;
          return;
        }else if(row < board.length-1 && board[row][col]==board[row+1][col]){
          gameStatus=Status.running;
          return;
        }
      }
    }
    gameStatus=Status.over;

    print("gameStatus:$gameStatus");
  }

  List<List<int>> addTwo2(board) {
    //get list of all location with empty spaces
    var emptySpaces = [];
    for (var row = 0; row < board.length; row++) {
      for (var col = 0; col < board[row].length; col++) {
        if (board[row][col] == 0) {
          var temp = [];
          temp.add(row);
          temp.add(col);
          emptySpaces.add(temp);
        }
      }
    }
    if (emptySpaces.length == 0) {
      return null;
    }

    List emptyPosition = emptySpaces[Random().nextInt(emptySpaces.length)];
    //now pick any random location from the emptySpaces array
    board[emptyPosition[0]][emptyPosition[1]] = 2;
    return board;
  }

  List<List<int>> playMove(board, move) {
    if (move == 'l' || move == 'L') return slideLeft(board);
    if (move == 'r' || move == 'R') return slideRight(board);
    if (move == 'u' || move == 'U') return slideUp(board);
    if (move == 'd' || move == 'D') return slideDown(board);
  }

  void printBoard(board) {
    for (var row = 0; row < board.length; row++) {
      print("${board[row]}" + "\n");
    }
  }

//only for console
  List<List<int>> play2048(board) {

    var tempBoard = board;
    var playerMove;
    playerMove = getNextMove();
    print("playerMove:" + playerMove);
    tempBoard = playMove(tempBoard, playerMove);
    //now check if game is won or not, if not then add 2 at any random place
    if (gameWon(tempBoard)) {
      print("Congraturlation, you won");
      print(tempBoard);
      return tempBoard;
    }
    //now add 2 at any random place
    board = addTwo2(tempBoard);
    if (board == null) {
      print("game over, no more empty spaces");
      print(
          tempBoard); //return previous board, which is tempBoard, otherwise, intial board will be updated and returned
      return tempBoard;
    }

    return play2048(board);
  }

  void slide(Function function) {
   function();
    moves++;
    updateGameStatus();
    if (gameStatus == Status.running) {
      addTwo2(board);
    }
  }

  void start() {
    board = [
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
    ];
    moves=0;
    addTwo2(board);
    gameStatus = Status.running;
  }
}

//void main(){
//  Game2048 game = Game2048();
//  game.start2048();
////print(leftSlide([1,1,0,0]));
////print(rightSlide([1,1,0,0]));
//}
enum Status { running, over, won }
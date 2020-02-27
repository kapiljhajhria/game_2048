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

class Game2048{
  List<List<int>> board = [
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
  ];

  List<int> leftSlide(List<int> numList) {
    int origSize = numList.length;
    numList = numList.where((a) => a != 0).toList(); //to filter out all zero
    var size = numList.length;
    for (int i = 0; i < size - 1; i++) {
      if (numList[i] == numList[i + 1]) {
        numList=removeElements(numList, i, i+1);
//      var temp = numList[i] + numList[i + 1]; //combine both integers
//      numList.splice(i, 2); //remove old elements
//      // numList.splice(i,1);
//      numList.splice(i, 0, temp); //add the sum at index i
        numList.add(0); //add zero in the end
        size--; //decrease size by 1, since we have replaced two items with 1
      }
    }
    //now to fill remaining array with zero
    // numList.fill(0, size, origSize+1)
    int fillRemainingArray = origSize - numList.length;
    for (var j = 0; j < fillRemainingArray; j++) {
      numList.add(0);
    }
    // console.log(numList);
    return numList;
  }
  removeElements(List<int> nums,int i, int j){
    int temp= nums[i]+nums[j];
    List<int> tempA= [];
    tempA.addAll(nums.sublist(0,i));
    tempA.add(temp);
    print(tempA);
    List<int> tempB=[];
    tempB.addAll(nums.sublist(j+1));
    print(tempB);

    tempA.addAll(tempB);
    return tempA;
  }
  rightSlide(List<int> numList) {
    return leftSlide(numList.reversed.toList()).reversed.toList();
  }



  transpose(List<List> matrix) {
    int n = matrix.length;
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) // only the upper is iterated
          {
        swap(matrix, [i,j], [j,i]);
      }
    }
    return matrix;
  }

  List swap(List matrix, List a,List b) {
    int buffer = matrix[a[0]][a[1]];
    matrix[a[0]][a[1]] = matrix[b[0]][b[1]] ;
    matrix[b[0]][b[1]] = buffer;
    return matrix;
  }

// console.log(transpose(board));
  List<List<int>> leftMoveBoard(List<List<int>>board) {
    // console.log(board);
    for (var i = 0; i < board.length; i++) {
      board[i] = leftSlide(board[i]);
    }
    return board;
  }

  List<List<int>> rightMoveBoard(List<List<int>> board) {
    for (var i = 0; i < board.length; i++) {
      board[i] = rightSlide(board[i]);
    }
    return board;
  }

  slideUp(board) {
    return transpose(transpose(transpose(leftMoveBoard(transpose(board)))));
  }
// console.log(slideUp(board));

  slideDown(board) {
    return transpose(transpose(transpose(rightMoveBoard(transpose(board)))));
  }
// console.log(slideDown(board));

  getNextMove() {
    var move;
    move = stdin.readLineSync();
    return move;
  }
// getNextMove();

  bool gameWon(board) {
    for (var row = 0; row < board.length; row++) {
      for (var col = 0; col < board[row].length; col++) {
        if (board[row][col] == 2048) {
          return true;
        }
      }
    }
    return false;
  }

  addTwo2(board) {
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
//    print("emptyspaces: ${emptySpaces.length}");
    //if there are no empty spcaes then return the board as it is
    if (emptySpaces.length == 0) return null;

    List emptyPosition = emptySpaces[Random().nextInt(emptySpaces.length)];
    //now pick any random location from the emptySpaces array
    board[emptyPosition[0]][emptyPosition[1]] = 2;
    return board;
  }

  playMove(board, move) {
    if (move == 'l' || move == 'L') return leftMoveBoard(board);
    if (move == 'r' || move == 'R') return rightMoveBoard(board);
    if (move == 'u' || move == 'U') return slideUp(board);
    if (move == 'd' || move == 'D') return slideDown(board);
  }

  printBoard(board) {
    for (var row = 0; row < board.length; row++) {
      print("${board[row]}" + "\n");
    }
  }

  play2048(board) {
    printBoard(board);
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

//play2048(board);
  start2048() {
    var board = [
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0]
    ];
    board = addTwo2(board);
    print("lets play 2048 game");
    play2048(board);
  }
  up(){
    slideUp(board);
    if(!gameWon(board)){
      addTwo2(board);
    }
  }
  down(){
    slideDown(board);
    if(!gameWon(board)){
      addTwo2(board);
    }
  }
  left(){
    leftMoveBoard(board);
    if(!gameWon(board)){
      addTwo2(board);
    }
  }
  right(){
    rightMoveBoard(board);
    if(!gameWon(board)){
      addTwo2(board);
    }
  }
  reset(){
    board=[
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
    ];
    addTwo2(board);
  }
  start(){
    addTwo2(board);
  }
}
//void main(){
//  Game2048 game = Game2048();
//  game.start2048();
////print(leftSlide([1,1,0,0]));
////print(rightSlide([1,1,0,0]));
//}

import 'package:flutter/material.dart';
import 'model/square.dart';
import 'dart:math' show Random;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum SquareType {
  zero,
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  bomb,
  facingDown,
  flagged,
}

class GameBoard extends StatelessWidget {
  int rowCount = 25;

  int columnCount = 10;

  List<List<BoardSquare>> boardSquares;

  List<bool> openedSquares;

  List<bool> flaggedSquares;

  int bombProbabilityLimit = 3;

  int maxSquareLimit = 15;

  int bombCount = 0;

  int squaresLeft;

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }

  getSquareTile(SquareType type){
    switch(type){
      case SquareType.zero:
        return Card(color: Colors.grey,);
      case SquareType.one:
        return Text('1');
      case SquareType.two:
        return Text('2');
      case SquareType.three:
        return Text('3');
      case SquareType.four:
        return Text('4');
      case SquareType.five:
        return Text('5');
      case SquareType.six:
        return Text('6');
      case SquareType.seven:
        return Text('7');
      case SquareType.eight:
        return Text('8');
      case SquareType.bomb:
        return Icon(FontAwesomeIcons.bomb);
      case SquareType.facingDown:
        return Icon(FontAwesomeIcons.smile);
      case SquareType.flagged:
        return Icon(FontAwesomeIcons.flag);
      default:
        return null;
    }
  }

  getSquareTypeFromNumber(int number){
    switch(number){
      case 0:
        return SquareType.zero;
      case 1:
        return SquareType.one;
      case 2:
        return SquareType.two;
      case 3:
        return SquareType.three;
      case 4:
        return SquareType.four;
      case 5:
        return SquareType.five;
      case 6:
        return SquareType.six;
      case 7:
        return SquareType.seven;
      case 8:
        return SquareType.eight;
      default:
        return null;
    }
  }
}
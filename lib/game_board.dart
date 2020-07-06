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

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
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
  void initState() {
    super.initState();
    initialiseGame();
  }

  void initialiseGame(){
    boardSquares = List.generate(rowCount, (index) => List.generate(columnCount, (index) => BoardSquare()));

    openedSquares = List.generate(rowCount * columnCount, (i) => false);

    flaggedSquares = List.generate(rowCount * columnCount, (i) => false);

    bombCount = 0;
    squaresLeft = rowCount * columnCount;

    Random random = new Random();
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        int randomNumber = random.nextInt(maxSquareLimit);
        if (randomNumber < bombProbabilityLimit) {
          boardSquares[i][j].hasBomb = true;
          bombCount++;
        }
      }
    }
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (i > 0 && j > 0) {
          if (boardSquares[i - 1][j - 1].hasBomb) {
            boardSquares[i][j].bombsAround++;
          }
        }

        if (i > 0) {
          if (boardSquares[i - 1][j].hasBomb) {
            boardSquares[i][j].bombsAround++;
          }
        }

        if (i > 0 && j < columnCount - 1) {
          if (boardSquares[i - 1][j + 1].hasBomb) {
            boardSquares[i][j].bombsAround++;
          }
        }

        if (j > 0) {
          if (boardSquares[i][j - 1].hasBomb) {
            boardSquares[i][j].bombsAround++;
          }
        }

        if (j < columnCount - 1) {
          if (boardSquares[i][j + 1].hasBomb) {
            boardSquares[i][j].bombsAround++;
          }
        }

        if (i < rowCount - 1 && j > 0) {
          if (boardSquares[i + 1][j - 1].hasBomb) {
            boardSquares[i][j].bombsAround++;
          }
        }

        if (i < rowCount - 1) {
          if (boardSquares[i + 1][j].hasBomb) {
            boardSquares[i][j].bombsAround++;
          }
        }

        if (i < rowCount - 1 && j < columnCount - 1) {
          if (boardSquares[i + 1][j + 1].hasBomb) {
            boardSquares[i][j].bombsAround++;
          }
        }
      }
    }
    setState((){});
  }

  void _handleTap(int i, int j) {

    int position = (i * columnCount) + j;
    openedSquares[position] = true;
    squaresLeft = squaresLeft - 1;

    if (i > 0) {
      if (!boardSquares[i - 1][j].hasBomb &&
          openedSquares[((i - 1) * columnCount) + j] != true) {
        if (boardSquares[i][j].bombsAround == 0) {
          _handleTap(i - 1, j);
        }
      }
    }

    if (j > 0) {
      if (!boardSquares[i][j - 1].hasBomb &&
          openedSquares[(i * columnCount) + j - 1] != true) {
        if (boardSquares[i][j].bombsAround == 0) {
          _handleTap(i, j - 1);
        }
      }
    }

    if (j < columnCount - 1) {
      if (!boardSquares[i][j + 1].hasBomb &&
          openedSquares[(i * columnCount) + j + 1] != true) {
        if (boardSquares[i][j].bombsAround == 0) {
          _handleTap(i, j + 1);
        }
      }
    }

    if (i < rowCount - 1) {
      if (!boardSquares[i + 1][j].hasBomb &&
          openedSquares[((i + 1) * columnCount) + j] != true) {
        if (boardSquares[i][j].bombsAround == 0) {
          _handleTap(i + 1, j);
        }
      }
    }

    setState(() {});
  }

  void _gameOver(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over!"),
          content: Text("Ooops!! You lost the game."),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                initialiseGame();
                Navigator.pop(context);
              },
              child: Text("Play again"),
            ),
          ],
        );
      },
    );
  }

  void _win(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Congratulations!"),
          content: Text("You Win!"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                initialiseGame();
                Navigator.pop(context);
              },
              child: Text("Play again"),
            ),
          ],
        );
      },
    );
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: MaterialButton(
          child: Icon(Icons.refresh),
          onPressed: (){
            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Refreshed'), duration: Duration(milliseconds: 500),));
            initialiseGame();
          },
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                ),
                itemBuilder: (context, position) {
                  int rowNumber = (position / columnCount).floor();
                  int columnNumber = (position % columnCount);

                  Widget _child;

                  if (openedSquares[position] == false) {
                    if (flaggedSquares[position] == true) {
                      _child = getSquareTile(SquareType.flagged);
                    } else {
                      _child = getSquareTile(SquareType.facingDown);
                    }
                  } else {
                    if (boardSquares[rowNumber][columnNumber].hasBomb) {
                      _child = getSquareTile(SquareType.bomb);
                    } else {
                      _child = getSquareTile(
                        getSquareTypeFromNumber(
                            boardSquares[rowNumber][columnNumber].bombsAround),
                      );
                    }
                  }

                  return InkWell(
                    onTap: () {
                      if (boardSquares[rowNumber][columnNumber].hasBomb) {
                        _gameOver(context);
                      }
                      if (boardSquares[rowNumber][columnNumber].bombsAround == 0) {
                        _handleTap(rowNumber, columnNumber);
                      } else {
                        setState(() {
                          openedSquares[position] = true;
                          squaresLeft = squaresLeft - 1;
                        });
                      }

                      if(squaresLeft <= bombCount) {
                        _win(context);
                      }

                    },
                    onLongPress: () {
                      if (openedSquares[position] == false) {
                        setState(() {
                          flaggedSquares[position] = true;
                        });
                      }
                    },
                    splashColor: Colors.grey,
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.05,
                      color: Colors.grey,
                      child: _child,
                    ),
                  );
                },
                itemCount: rowCount * columnCount,
              ),
            ),
      ),
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
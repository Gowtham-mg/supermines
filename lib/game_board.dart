import 'dart:async';

import 'package:flutter/material.dart';
import 'model/square.dart';
import 'dart:math' show Random;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


enum TileState { defaultBoard, blown, open, flagged, revealed }
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

int rowCount;
int columnCount;

void updateCount(int row, int column){
  rowCount = row;
  columnCount = column;
}

class GameBoard extends StatefulWidget {
  
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {


  List<List<BoardSquare>> boardSquares;

  List<bool> openedSquares;

  List<bool> flaggedSquares;

  int bombProbabilityLimit = 3;

  int maxSquareLimit = 15;

  int bombCount = 0;

  int bombRemaining = 0;
  bool alive = true;
  bool wonGame = false;
  int minesFound = 0;
  Timer timer;
  Stopwatch stopwatch=Stopwatch();

  int squaresLeft;
  int totalSquares;

  @override
  void initState() {
    super.initState();
    initialiseGame();
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void reset(){
    minesFound = 0;
    bombRemaining = 0;
    stopwatch.stop();
    stopwatch.reset();
    timer?.cancel();
    setState(() {
      
    });
  }

  void initialiseGame(){
    
    boardSquares = List.generate(rowCount, (index) => List.generate(columnCount, (index) => BoardSquare()));

    openedSquares = List.generate(rowCount * columnCount, (i) => false);

    flaggedSquares = List.generate(rowCount * columnCount, (i) => false);

    bombCount = 0;
    squaresLeft = rowCount * columnCount;
    totalSquares = rowCount * columnCount;

    Random random = new Random();
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        int randomNumber = random.nextInt(maxSquareLimit);
        if (randomNumber < bombProbabilityLimit) {
          boardSquares[i][j].hasBomb = true;
          bombCount++;
          bombRemaining++;
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

    setState(() {});
  }

  void _gameOver(context) {
    timer.cancel();
    stopwatch.stop();
    timer = null;
    setState(() {
      
    });
    showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(

          title: Text("Game Over!"),
          content: Container(
            height: MediaQuery.of(context).size.height *0.3,
            child: Column(children:[
              Text('Number of mines found $minesFound'),
              SizedBox(height: 10,),
              Text('Number of mines left $bombRemaining'),
              SizedBox(height: 10,),
              Text('Time taken ${stopwatch.elapsedMilliseconds~/1000}'),
              SizedBox(height:10),
              Text("Number of squares opened ${totalSquares-squaresLeft}"),
              SizedBox(height:10),
              Text("Ooops!! You lost the game."),
            ],)
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("Play again"),
            ),
          ],
        );
      },
    );
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


  void _win(context) {
    stopwatch.stop();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Congratulations!"),
          content: Text("You Win!"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
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
    int timeElapsed = stopwatch.elapsedMilliseconds ~/ 1000;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            Spacer(flex: 3,),
            Text('Super Mines'),
            Spacer(flex: 1,),
            MaterialButton(
              child: Icon(Icons.refresh),
              onPressed: (){
                reset();
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Refreshed',), duration: Duration(milliseconds: 500),));
                initialiseGame();
              },
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                  height: 40.0,
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      text: wonGame ? "You won, $timeElapsed seconds" : alive ? "[Time: $timeElapsed seconds]  [Mines found: $minesFound]  [Mines remaining: $bombRemaining]  [Total mines: $bombCount]" : "You lost in $timeElapsed seconds",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1.5)
                    ),
                  ),
                )
            ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
              child: GridView.builder(
                padding: EdgeInsets.all(1),
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
                      timer = timer ??Timer.periodic(Duration(seconds: 1), (Timer timer) {
                        setState(() {
                          
                        });
                      });
                      if(!stopwatch.isRunning) stopwatch.start();
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
                        if(boardSquares[rowNumber][columnNumber].hasBomb){
                          setState(() {
                            print(position%10);
                            bombRemaining -= 1;
                            minesFound++;
                            flaggedSquares[position] = true;
                            squaresLeft = squaresLeft - 1;
                          });
                        }else{
                          setState(() {
                            print(position);
                            flaggedSquares[position] = true;
                            squaresLeft = squaresLeft - 1;
                          });
                        }
                      }
                    },
                    splashColor: Colors.grey,
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.05,
                      color: Colors.white,
                      child: Card(
                        color: Colors.grey.shade400,
                        shadowColor: Colors.grey.shade300,
                        elevation: 5,
                        child: _child
                      ),
                    ),
                  );
                },
                itemCount: rowCount * columnCount,
              ),
            ),
      ),
    );
  }

  TextStyle textStyle = TextStyle(fontSize: 17,);

  getSquareTile(SquareType type){
    switch(type){
      case SquareType.zero:
        return Card(color: Colors.grey,);
      case SquareType.one:
        return Center(child: Text('1', style: textStyle,),);
      case SquareType.two:
        return Center(child: Text('2', style: textStyle,));
      case SquareType.three:
        return Center(child: Text('3', style: textStyle,));
      case SquareType.four:
        return Center(child: Text('4', style: textStyle,));
      case SquareType.five:
        return Center(child: Text('5', style: textStyle,));
      case SquareType.six:
        return Center(child: Text('6', style: textStyle,));
      case SquareType.seven:
        return Center(child: Text('7', style: textStyle,));
      case SquareType.eight:
        return Center(child: Text('8', style: textStyle,));
      case SquareType.bomb:
        return Icon(FontAwesomeIcons.bomb);
      case SquareType.facingDown:
        return null;
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
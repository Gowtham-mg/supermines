import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'game_board.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  
  Animation<double> animation;            
  AnimationController controller;
  @override            
  void initState() {            
    super.initState();            
    controller = AnimationController(duration: const Duration(seconds: 1), vsync: this, value: 0.1);                  
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceInOut);
    controller.forward();
    controller.repeat(reverse:true);
  }
  PageController _pageController;
  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blueGrey.shade100,
      body: PageView(
        controller: _pageController ,
        // onPageChanged: (index){
        //   if(index==1 && controller != null){
        //     controller.dispose();
        //   }
          // _pageController.dispose();
        // },
        children: [
          Stack(
          children: [
            Center(
              child: ScaleTransition(
                scale: controller,
                  child: Icon(
                  FontAwesomeIcons.bomb,
                  size: size.width * 0.3,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)
                  )
                ),
                height: size.height * 0.1,
                child: Center(child: Text('Swipe Right to start', style: TextStyle(color: Colors.white, fontSize: size.height*0.03),)),
                width: double.infinity,
              ),
            )
          ],
        ),
        Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              shape: StadiumBorder(side: BorderSide(color: Colors.orange, style: BorderStyle.solid, width: 1)),
              elevation: 5,
              child: Text('Easy'),
              onPressed: (){
                controller.stop();
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Your board is getting ready'),duration: Duration(seconds: 1),));
                updateCount(10, 6);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> GameBoard()));
              },
                color: Colors.orange.shade200
            ),
            SizedBox(height: 10,),
            RaisedButton(
              animationDuration: Duration(seconds: 1),
                shape: StadiumBorder(side: BorderSide(color: Colors.orange, style: BorderStyle.solid, width: 1)),
                elevation: 5,
                child: Text('Medium'),
                onPressed: (){
                controller.stop();
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Your board is getting ready'),duration: Duration(seconds: 2),));
                updateCount(13, 8);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> GameBoard()));
              },
                color: Colors.orange.shade300,
              autofocus: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
            ),
            SizedBox(height: 10,),
            RaisedButton(             
              animationDuration: Duration(seconds: 1),
              autofocus: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: StadiumBorder(side: BorderSide(color: Colors.orange, style: BorderStyle.solid, width: 1)),
              elevation: 5,
              child: Text('Hard'),
                color: Colors.orange.shade200,
              onPressed: (){
                controller.stop();
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Your board is getting ready'),duration: Duration(seconds: 3),));
                updateCount(15, 10);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> GameBoard()));
              },
            ),
          ],
        ),
      )
        ]
      )
    );
  }
}


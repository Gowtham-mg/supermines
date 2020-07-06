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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: PageView(
        controller: _pageController ,
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
            Text('Welcome to supermines', style: TextStyle(letterSpacing: 2, fontSize: 20, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600), ),
            SizedBox(height: 20,),
            RaisedButton(
              shape: StadiumBorder(side: BorderSide(color: Colors.orange, style: BorderStyle.solid, width: 1)),
              elevation: 5,
              child: Text('Easy',style: TextStyle(fontSize: 18),),
              onPressed: (){
                controller.stop();
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
                child: Text('Medium',style: TextStyle(fontSize: 18),),
                onPressed: (){
                controller.stop();
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
              child: Text('Hard', style: TextStyle(fontSize: 18),),
                color: Colors.orange.shade300,
              onPressed: (){
                controller.stop();
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


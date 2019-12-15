import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShultCell(),
    );
  }
}

class ShultCell extends StatefulWidget {
  ShultCell({Key key}) : super(key: key);

  @override
  _ShultCellState createState() => _ShultCellState();
}

class _ShultCellState extends State<ShultCell> with TickerProviderStateMixin {
  int count;
  List<int> data = List<int>();
  List<int> curSel = List<int>();
  List<AnimationController> controllers = List<AnimationController>();
  List<Animation<Color>> animations = List<Animation<Color>>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    count = 25;
    List.generate(count, (index) {
      data.add(index + 1);
      controllers.add(AnimationController(vsync: this, duration: Duration(milliseconds: 250)));
      animations.add(
        ColorTween(begin: Colors.white, end: Colors.purpleAccent)
        .animate(controllers[index])..addListener((){
          setState(() {
            
          });
        })
      );
    });



    data.shuffle();


  }

  tapCell(i){

    int lastSel = curSel.length > 0 ? curSel.last : 0;
    if(data[i] -1 == lastSel) {
      animations[i] = ColorTween(begin: Colors.white, end: Colors.purpleAccent)
        .animate(controllers[i])..addListener((){
          setState(() {
            
          });
        });
        curSel.add(data[i]);
    } else {
      animations[i] = ColorTween(begin: Colors.white, end: Colors.redAccent)
        .animate(controllers[i])..addListener((){
          setState(() {
            
          });
        });
    }

    controllers[i].forward(from: 0).then((_) => {
      controllers[i].reverse()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('舒尔特方格'),
      ),
      body: GridView.count(
        crossAxisCount: 5,
        children: List.generate(count, (index) {
          return GestureDetector(
            onTap: (){
              tapCell(index);
            },
            child: Container(
              decoration: BoxDecoration(border: Border.all(width: 1), color: animations[index].value),
              alignment: Alignment.center,
              child: Text(
                  "${data[index]}",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                )
            )
          );
        }),
      ),
    );
  }
}

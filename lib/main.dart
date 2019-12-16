import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shult_grid/addProvider.dart';

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
  var table = AnimContainer();
  var timer = CountTimer();
  reset() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('舒尔特方格'),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MainProvider(),
          )
        ],
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            SizedBox(
              height: 450.0,
              child: table,
            ),
            timer
          ],
        ),
      ),
    );
  }
}

// 计时器部分
class CountTimer extends StatefulWidget {
  CountTimer({Key key}) : super(key: key);

  _CountTimerState createState() => _CountTimerState();
}

class _CountTimerState extends State<CountTimer> {
  Timer time;
  double totalTime = 0;
  bool ifStarted = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MainProvider>(context);

    return SizedBox(
        height: 200,
        child: Column(
          children: [
            Expanded(
                flex: 5,
                child: Center(
                  child: Text(
                    "${provider.totalTime.toStringAsFixed(1)}",
                    style: TextStyle(fontSize: 20),
                  ),
                )),
            Container(
                child: Flexible(
              flex: 2,
              child: MaterialButton(
                // padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                splashColor: Colors.transparent,
                color: Colors.blueAccent,
                onPressed: () {
                  provider.changeCount();
                },
                child: Text(
                  provider.count == 16 ? "25格" : "16格",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )),
            Container(
                child: Flexible(
              flex: 2,
              child: MaterialButton(
                // padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                splashColor: Colors.transparent,
                color: Colors.blueAccent,
                onPressed: () {
                  provider.resetValue();
                },
                child: Text(
                  "换一题",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )),
          ],
        ));
  }
}

// 动画部分
class AnimContainer extends StatefulWidget {
  AnimContainer({Key key}) : super(key: key);

  @override
  _AnimContainerState createState() => _AnimContainerState();
}

class _AnimContainerState extends State<AnimContainer>
    with TickerProviderStateMixin {
  // int count;
  // List<int> data = List<int>();
  // List<int> curSel = List<int>();
  // List<AnimationController> controllers = List<AnimationController>();
  // List<Animation<Color>> animations = List<Animation<Color>>();
  List<Color> conColor = List<Color>();
  List<int> data = List<int>();
  List<int> curSel = List<int>();

  List<Animation<Color>> animation;
  List<AnimationController> controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animation = List<Animation<Color>>();
    controller = List<AnimationController>();
    curSel = List<int>();
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   count = 25;
  //   List.generate(count, (index) {
  //     data.add(index + 1);
  //     controllers.add(AnimationController(vsync: this, duration: Duration(milliseconds: 250)));
  //     animations.add(
  //       ColorTween(begin: Colors.white, end: Colors.purpleAccent)
  //       .animate(controllers[index])..addListener((){
  //         setState(() {

  //         });
  //       })
  //     );
  //   });

  //   data.shuffle();

  // }

  // tapCell(i){

  //   int lastSel = curSel.length > 0 ? curSel.last : 0;
  //   if(data[i] -1 == lastSel) {
  //     animations[i] = ColorTween(begin: Colors.white, end: Colors.purpleAccent)
  //       .animate(controllers[i])..addListener((){
  //         setState(() {

  //         });
  //       });
  //       curSel.add(data[i]);
  //   } else {
  //     animations[i] = ColorTween(begin: Colors.white, end: Colors.redAccent)
  //       .animate(controllers[i])..addListener((){
  //         setState(() {

  //         });
  //       });
  //   }

  //   controllers[i].forward(from: 0).then((_) => {
  //     controllers[i].reverse()
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MainProvider>(context);
    int count = provider.count;
    for (int i = 0; i < count; i++) {
      controller.add(AnimationController(
          duration: Duration(milliseconds: 500), vsync: this));
      animation.add(ColorTween(begin: Colors.white, end: Colors.purpleAccent)
          .animate(controller[i])
            ..addListener(() {
              setState(() {});
            }));
    }
    provider.animation = animation;
    provider.controller = controller;

    return GridView.count(
      crossAxisCount: sqrt(count).round(),
      children: List.generate(
          count,
          (i) => GestureDetector(
              onTap: () {
                provider.tapCell(i);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: provider.animation[i].value,
                  border: Border.all(width: 1),
                ),
                child: Container(
                  child: Text(
                    "${provider.data[i]}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  padding: EdgeInsets.all(count == 25 ? 10 : 20),
                ),
              ))).toList(),
    );
  }
}

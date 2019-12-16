import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainProvider extends ChangeNotifier {
  Timer time;
  double totalTime = 0;
  bool ifStarted = false;
  int totalCell = 0;
  int count = 25;

  List<Color> conColor = List<Color>();
  List<int> data = List<int>();
  List<int> curSel = List<int>();
  // AnimationController animController;

  List<Animation<Color>> animation;
  List<AnimationController> controller;

  MainProvider() {
    ifStarted = false;
    totalCell = count;
    if (ifStarted) {
      time.cancel();
    }

    totalTime = 0;
    List.generate(totalCell, (i) {
      conColor.add(Colors.white);
    });

    data = List<int>();
    List.generate(totalCell, (i) => data.add(i + 1));
    data.shuffle();
    curSel = List<int>();
  }

  // 重置状态
  resetValue() {
    if (ifStarted) {
      time.cancel();
    }
    ifStarted = false;

    totalTime = 0;
    conColor = List.generate(totalCell, (i) => conColor[i] = Colors.white);

    data = List<int>();
    List.generate(totalCell, (i) => data.add(i + 1)).toList()..shuffle();
    data.shuffle();
    curSel = List<int>();
    notifyListeners();
  }

  ifLastCorrect() {
    if (curSel.length == count && curSel.last == count) {
      time.cancel();
    }
  }

  tapStart() {
    if (!ifStarted) {
      time = Timer.periodic(Duration(milliseconds: 100), (_) {
        totalTime += 0.1;
        totalTime = totalTime;
        notifyListeners();
      });
      ifStarted = true;
    } else {
      time.cancel();
      ifStarted = false;
    }
    notifyListeners();
  }

  startPlay() {
    if (!ifStarted) {
      tapStart();
    }
  }

  changeCount() {
    if (count == 16) {
      count = 25;
    } else {
      count = 16;
    }
    if (ifStarted) {
      time.cancel();
    }
    totalCell = count;
    // resetValue();
    curSel = List<int>();
    data = List<int>();
    List.generate(totalCell, (i) => data.add(i + 1)).toList()..shuffle();
    data.shuffle();
    totalTime = 0;
    ifStarted = false;
    notifyListeners();
  }

  tapCell(i) {
    int prevValue = curSel.length > 0 ? curSel.last : 0;
    startPlay();

    if (data[i] - prevValue != 1) {
      animation[i] = ColorTween(
        begin: Colors.white,
        end: Colors.red,
      ).animate(controller[i])
        ..addListener(() {});
    } else {
      animation[i] = ColorTween(
        begin: Colors.white,
        end: Colors.purpleAccent,
      ).animate(controller[i])
        ..addListener(() {});
      curSel.add(data[i]);
      curSel = curSel;
    }

    if (data[i] == totalCell && curSel.length == totalCell) {
      time.cancel();
      Fluttertoast.showToast(
          msg: "恭喜你，在${totalTime.toStringAsFixed(1)}秒内完成~",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.green[700],
          textColor: Colors.white,
          fontSize: 16.0);
    }
    notifyListeners();
    controller[i].forward(from: 0).then((_) => controller[i].reverse());
  }
}

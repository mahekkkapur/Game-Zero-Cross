import 'dart:math';

import 'package:flutter/material.dart';
import 'package:Game-Zero-Cross-1/custom_dailog.dart';
import 'package:Game-Zero-Cross-1/game_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<playingB> buttonsList;
  var participant1;
  var participant2;
  var activeparticipant;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonsList = doInit();
  }

  List<playingB> doInit() {
    participant1 = new List();
    participant2 = new List();
    activeparticipant = 1;

    var playingBs = <playingB>[
      new playingB(id: 1),
      new playingB(id: 2),
      new playingB(id: 3),
      new playingB(id: 4),
      new playingB(id: 5),
      new playingB(id: 6),
      new playingB(id: 7),
      new playingB(id: 8),
      new playingB(id: 9),
    ];
    return playingBs;
  }

  void playGame(playingB plb) {
    setState(() {
      if (activeparticipant == 1) {
        plb.text = "X";
        plb.bg = Colors.blue;
        activeparticipant = 2;
        participant1.add(plb.id);
      } else {
        plb.text = "0";
        plb.bg = Colors.yellow;
        activeparticipant = 1;
        participant2.add(plb.id);
      }
      plb.enabled = false;
      int champion = checkchampion();
      if (champion == -1) {
        if (buttonsList.every((p) => p.text != "")) {
          showDialog(
              context: context,
              builder: (_) => new CustomDialog("Game Tied",
                  "Select reset button to Re-start.", resetGame));
        } else {
          activeparticipant == 2 ? autoPlay() : null;
        }
      }
    });
  }

  void autoPlay() {
    var emptyCells = new List();
    var list = new List.generate(9, (i) => i + 1);
    for (var cellID in list) {
      if (!(participant1.contains(cellID) || participant2.contains(cellID))) {
        emptyCells.add(cellID);
      }
    }

    var r = new Random();
    var randIndex = r.nextInt(emptyCells.length-1);
    var cellID = emptyCells[randIndex];
    int i = buttonsList.indexWhere((p)=> p.id == cellID);
    playGame(buttonsList[i]);

  }

  int checkchampion() {
    var champion = -1;
    if (participant1.contains(1) && participant1.contains(2) && participant1.contains(3)) {
      champion = 1;
    }
    if (participant2.contains(1) && participant2.contains(2) && participant2.contains(3)) {
      champion = 2;
    }

    // row 2
    if (participant1.contains(4) && participant1.contains(5) && participant1.contains(6)) {
      champion = 1;
    }
    if (participant2.contains(4) && participant2.contains(5) && participant2.contains(6)) {
      champion = 2;
    }

    // row 3
    if (participant1.contains(7) && participant1.contains(8) && participant1.contains(9)) {
      champion = 1;
    }
    if (participant2.contains(7) && participant2.contains(8) && participant2.contains(9)) {
      champion = 2;
    }

    // col 1
    if (participant1.contains(1) && participant1.contains(4) && participant1.contains(7)) {
      champion = 1;
    }
    if (participant2.contains(1) && participant2.contains(4) && participant2.contains(7)) {
      champion = 2;
    }

    // col 2
    if (participant1.contains(2) && participant1.contains(5) && participant1.contains(8)) {
      champion = 1;
    }
    if (participant2.contains(2) && participant2.contains(5) && participant2.contains(8)) {
      champion = 2;
    }

    // col 3
    if (participant1.contains(3) && participant1.contains(6) && participant1.contains(9)) {
      champion = 1;
    }
    if (participant2.contains(3) && participant2.contains(6) && participant2.contains(9)) {
      champion = 2;
    }

    //diagonal
    if (participant1.contains(1) && participant1.contains(5) && participant1.contains(9)) {
      champion = 1;
    }
    if (participant2.contains(1) && participant2.contains(5) && participant2.contains(9)) {
      champion = 2;
    }

    if (participant1.contains(3) && participant1.contains(5) && participant1.contains(7)) {
      champion = 1;
    }
    if (participant2.contains(3) && participant2.contains(5) && participant2.contains(7)) {
      champion = 2;
    }

    if (champion != -1) {
      if (champion == 1) {
        showDialog(
            context: context,
            builder: (_) => new CustomDialog("participant 1 Won",
                "Select reset button to Re-start.", resetGame));
      } else {
        showDialog(
            context: context,
            builder: (_) => new CustomDialog("participant 2 Won",
                "Select reset button to Re-start.", resetGame));
      }
    }

    return champion;
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonsList = doInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Tic Tac Toe"),
        ),
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Expanded(
              child: new GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 9.0,
                    mainAxisSpacing: 9.0),
                itemCount: buttonsList.length,
                itemBuilder: (context, i) => new SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: new RaisedButton(
                        padding: const EdgeInsets.all(8.0),
                        onPressed: buttonsList[i].enabled
                            ? () => playGame(buttonsList[i])
                            : null,
                        child: new Text(
                          buttonsList[i].text,
                          style: new TextStyle(
                              color: Colors.white, fontSize: 20.0),
                        ),
                        color: buttonsList[i].bg,
                        disabledColor: buttonsList[i].bg,
                      ),
                    ),
              ),
            ),
            new RaisedButton(
              child: new Text(
                "Reset",
                style: new TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              color: Colors.blue,
              padding: const EdgeInsets.all(20.0),
              onPressed: resetGame,
            )
          ],
        ));
  }
}

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

import 'package:trex/game/game.dart';
import 'package:trex/sd.dart';

void main() {
  //Flame.device.fullScreen();
  runApp(
    GetMaterialApp(
      title: 'TRexGame',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: TRexGameWrapper(),
      ),
    ),
  );
}

class TRexGameWrapper extends StatefulWidget {
  @override
  _TRexGameWrapperState createState() => _TRexGameWrapperState();
}

class _TRexGameWrapperState extends State<TRexGameWrapper> {
  ScoreController scoreController = Get.put(ScoreController());
  bool splashGone = false;
  TRexGame? game;
  final _focusNode = FocusNode();
  int finalScore = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    Flame.images.loadAll([
      "sprite.png",
      "characterSprite.png",
      "streetRed.png",
      "streetRed2.jpg",
      "gameover.png",
      "playbutton.png"
    ]).then(
      (image) => {
        setState(() {
          game = TRexGame(
              spriteImage: image[0],
              spriteCharacter: image[1],
              spriteStreet: image[2],
              spriteStreet2: image[3],
              gameOverSprite: image[4],
              replaySprite: image[5]);
          _focusNode.requestFocus();
        })
      },
    );
  }

  void onRawKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      game!.onAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (game == null) {
      return const Center(
        child: Text("Loading"),
      );
    }
    return Stack(
      children: [
        Container(
          color: Colors.white,
          constraints: const BoxConstraints.expand(),
          child: RawKeyboardListener(
            focusNode: _focusNode,
            onKey: onRawKeyEvent,
            child: GameWidget(
              game: game!,
            ),
          ),
        ),
        Obx(() {
          return Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Text(
                "Score : ${scoreController.count.value}",
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.orange[200],
                    fontFamily: "Blomberg"),
              ));
        }),
      ],
    );
  }
}

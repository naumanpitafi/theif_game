import 'dart:async' as timer;

import 'dart:ui' as ui hide TextStyle;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:get/get.dart';
import 'package:trex/game/background/backhorizon.dart';
import 'package:trex/game/game_config.dart';
import 'package:trex/game/game_over/config.dart';
import 'package:trex/game/game_over/game_over.dart';
import 'package:trex/game/horizon/horizon.dart';
import 'package:trex/game/obstacle/obstacle.dart';
import 'package:trex/game/t_rex/t_rex.dart';
import 'package:trex/sd.dart';

import 'collision/collision_utils.dart';

class Bg extends Component with HasGameRef {
  Vector2 size = Vector2.zero();

  late final ui.Paint _paint = ui.Paint()
    ..color = ui.Color.fromARGB(255, 44, 44, 44);

  @override
  void render(ui.Canvas c) {
    final rect = ui.Rect.fromLTWH(0, 0, size.x, size.y);
    c.drawRect(rect, _paint);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    size = gameSize;
  }
}

enum TRexGameStatus { playing, waiting, gameOver }

class TRexGame extends FlameGame with TapDetector {
  TRexGame(
      {required this.spriteImage,
      required this.spriteCharacter,
      required this.spriteStreet2,
      required this.gameOverSprite,
      required this.replaySprite,
      required this.spriteStreet})
      : super();

  late final config = GameConfig();

  @override
  ui.Color backgroundColor() => ui.Color.fromARGB(255, 44, 44, 44);

  final ui.Image spriteImage;
  final ui.Image spriteCharacter;
  final ui.Image spriteStreet;
  final ui.Image spriteStreet2;
  final ui.Image gameOverSprite;
  final ui.Image replaySprite;
  int currentTime3 = 0;

  /// children
  late final tRex = TRex();
  late final horizon = Horizon();
  late final backhorizon = BckgroundHorizon();
  late final gameOverPanel =
      GameOverPanel(replaySprite, gameOverSprite, GameOverConfig());

  @override
  Future<void> onLoad() async {
    add(Bg());
    add(horizon);
    add(backhorizon);
    add(tRex);
    add(gameOverPanel);
  }

  ScoreController scoreController = Get.find();
  // state
  late TRexGameStatus status = TRexGameStatus.waiting;
  late double currentSpeed = 0.0;
  late double timePlaying = 0.0;
  late int dis = 0;

  bool get playing => status == TRexGameStatus.playing;

  bool get gameOver => status == TRexGameStatus.gameOver;
  CountTimer countTimer = CountTimer();
  @override
  void onTapDown(TapDownInfo event) {
    onAction();
  }

  void onAction() {
    if (gameOver) {
      restart();
      return;
    }
    tRex.startJump(currentSpeed);
  }

  void startGame() {
    print("start");
    tRex.status = TRexStatus.running;
    status = TRexGameStatus.playing;
    tRex.hasPlayedIntro = true;
    currentSpeed = config.speed;
    dis = 0;
    countTimer.startTimer();
    scoreController.increment(0);
  }

  void doGameOver() {
    gameOverPanel.visible = true;
    status = TRexGameStatus.gameOver;
    tRex.status = TRexStatus.crashed;
    currentSpeed = 0.0;
    dis = 0;
  }

  void restart() {
    print("Restart");
    status = TRexGameStatus.playing;
    tRex.reset();
    horizon.reset();
    backhorizon.reset();
    currentTime3 = 0;
    currentSpeed = config.speed;
    gameOverPanel.visible = false;
    timePlaying = 0.0;
    dis = 0;
    scoreController.increment(0);
    countTimer.startTimer();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameOver) {
      return;
    }

    if (tRex.playingIntro && tRex.x >= tRex.config.startXPos) {
      startGame();
    } else if (tRex.playingIntro) {}

    if (playing) {
      timePlaying += dt;
      final obstacles = horizon.horizonLine.obstacleManager.children;
      final hasCollision = obstacles.isNotEmpty &&
          checkForCollision(obstacles.first as Obstacle, tRex);

      if (!hasCollision) {
        if (currentSpeed < config.maxSpeed) {
          currentSpeed += config.acceleration;

          currentTime3 = DateTime.now().second;
          // 𝑠=𝑢𝑡+12𝑎𝑡2
          // the distance
          // dis = ((currentSpeed * currentTime) +
          //         ((config.acceleration * (currentTime * currentTime)) / 2))
          //     .toInt();

          print(" the timer " + countTimer.getTime().toString());

          dis = (currentSpeed * countTimer.getTime()).toInt();
          scoreController.increment(dis);
        }
      } else {
        countTimer.stopTimer();
        doGameOver();
      }
    }
  }
}

class CountTimer {
  late timer.Timer time;
  int _current = 0;
  void startTimer() {
    _current = 0;
    time = timer.Timer.periodic(Duration(seconds: 1), (timer) {
      _current++;
    });

    // CountdownTimer countDownTimer = new CountdownTimer(
    //   Duration(seconds: _start),
    //   Duration(seconds: 1),
    // );

    // var sub = countDownTimer.listen(null);
    // sub.onData((duration) {
    //   _current = _start - duration.elapsed.inSeconds;
    // });

    // sub.onDone(() {
    //   print("Done");
    //   sub.cancel();
    // });
  }

  int getTime() {
    return _current;
  }

  void stopTimer() {
    time.cancel();
  }
}

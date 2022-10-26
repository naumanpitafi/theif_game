import 'dart:ui';

import 'package:flame/components.dart';
import 'package:trex/game/game.dart';

import 'config.dart';

class GameOverPanel extends Component with HasGameRef<TRexGame> {
  GameOverPanel(
    Image spriteImage,
    Image gemeoverImage,
    GameOverConfig config,
  )   : gameOverText = GameOverText(gemeoverImage, config),
        gameOverRestart = GameOverRestart(spriteImage, config),
        super();

  bool visible = false;

  GameOverText gameOverText;
  GameOverRestart gameOverRestart;

  @override
  Future<void>? onLoad() {
    add(gameOverText);
    add(gameOverRestart);
    return super.onLoad();
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}

class GameOverText extends SpriteComponent {
  GameOverText(Image spriteImage, this.config)
      : super(
          size: Vector2(300, 63.54),
          sprite: Sprite(
            spriteImage,
            srcPosition: Vector2(0, 0.0),
            srcSize: Vector2(
              config.textWidth,
              config.textHeight,
            ),
          ),
        );

  final GameOverConfig config;

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    y = gameSize.y * .25 - 80;
    x = (gameSize.x / 2) - 150;
    // x = gameSize
  }
}

class GameOverRestart extends SpriteComponent {
  GameOverRestart(
    Image spriteImage,
    this.config,
  ) : super(
          size: Vector2(200, 85.63),
          sprite: Sprite(
            spriteImage,
            srcPosition: Vector2(0, 0.0),
            srcSize: Vector2(config.restartWidth, config.restartHeight),
          ),
        );

  final GameOverConfig config;

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    y = gameSize.y * .25 + 410;
    x = (gameSize.x / 2) - 100;
    // y = gameSize.y * .75;
    // x = (gameSize.x / 2) - config.restartWidth / 2;
  }
}

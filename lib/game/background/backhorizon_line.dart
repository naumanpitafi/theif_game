import 'package:flame/components.dart';

import '../game.dart';
import 'backconfig.dart';

class BackGroungHorizonLine extends PositionComponent
    with HasGameRef<TRexGame> {
  late final dimensions = HorizonDimensions();

  late final _softSprite = Sprite(
    gameRef.spriteStreet2,
    srcPosition: Vector2(0.0, 0.0),
    srcSize: Vector2(dimensions.width, dimensions.height),
  );

  // late final _bumpySprite = Sprite(
  //   gameRef.spriteImage,
  //   srcPosition: Vector2(2.0 + dimensions.width, 104.0),
  //   srcSize: Vector2(dimensions.width, dimensions.height),
  // );

  // grounds
  late final firstGround = HorizonGround(_softSprite, dimensions);
  late final secondGround = HorizonGround(_softSprite, dimensions);
  late final thirdGround = HorizonGround(_softSprite, dimensions);

  // children

  @override
  void onMount() {
    add(firstGround);
    add(secondGround);
    add(thirdGround);
    super.onMount();
  }

  void updateXPos(int indexFirst, double increment) {
    final grounds = [firstGround, secondGround, thirdGround];

    final first = grounds[indexFirst];
    final second = grounds[(indexFirst + 1) % 3];
    final third = grounds[(indexFirst + 2) % 3];

    first.x -= increment;
    second.x = first.x + dimensions.width;
    third.x = second.x + dimensions.width;

    if (first.x <= -dimensions.width) {
      first.x += dimensions.width * 3;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    final increment = 0.5;
    // gameRef.currentSpeed * 50 * dt;
    final index = firstGround.x <= 0
        ? 0
        : secondGround.x <= 0
            ? 1
            : 2;
    if (gameRef.status == TRexGameStatus.playing) {
      updateXPos(index, increment);
    }
  }

  void reset() {
    // cloudManager.reset();
    // obstacleManager.reset();

    firstGround.x = 0.0;
    secondGround.x = dimensions.width;
  }
}

class HorizonGround extends SpriteComponent {
  HorizonGround(Sprite sprite, HorizonDimensions dimensions)
      : super(
          size: Vector2(1200, 600),
          sprite: sprite,
        );
}

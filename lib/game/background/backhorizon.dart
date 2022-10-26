import 'package:flame/components.dart';

import '../game.dart';
import 'backhorizon_line.dart';

class BckgroundHorizon extends PositionComponent with HasGameRef<TRexGame> {
  late final horizonLine = BackGroungHorizonLine();

  @override
  Future<void>? onLoad() {
    add(horizonLine);
  }

  @override
  void update(double dt) {
    y = 0;
    super.update(dt);
  }

  void reset() {
    horizonLine.reset();
  }
}

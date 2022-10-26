import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ScoreController extends GetxController {
  var count = 0.obs;
  void increment(int valu) {
    count.value = valu;
  }
}

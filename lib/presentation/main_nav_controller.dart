import 'package:get/get.dart';

class MainNavController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
    }
  }
}

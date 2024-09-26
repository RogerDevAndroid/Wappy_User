
import 'package:get/get.dart';
import 'package:user/app/controller/categories_controller.dart';

class CategoriesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => CategoriesController(parser: Get.find()));
  }
}

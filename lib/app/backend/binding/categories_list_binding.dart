
import 'package:get/get.dart';
import 'package:user/app/controller/categories_list_controller.dart';

class CategoriesListBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => CategoriesListController(parser: Get.find()));
  }
}


import 'package:get/get.dart';
import 'package:user/app/controller/top_products_controller.dart';

class TopProductsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => TopProductsControllrer(parser: Get.find()));
  }
}

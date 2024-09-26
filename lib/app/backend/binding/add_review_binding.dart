
import 'package:get/get.dart';
import 'package:user/app/controller/add_review_controller.dart';

class AddReviewBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => AddReviewController(parser: Get.find()));
  }
}

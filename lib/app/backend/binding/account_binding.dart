
import 'package:get/get.dart';
import 'package:user/app/controller/account_controller.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => AccountController(parser: Get.find()));
  }
}

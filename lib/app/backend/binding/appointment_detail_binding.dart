
import 'package:get/get.dart';
import 'package:user/app/controller/appointment_detail_controller.dart';

class AppointmentDetailBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => AppointmentDetailController(parser: Get.find()));
  }
}

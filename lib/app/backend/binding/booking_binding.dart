
import 'package:get/get.dart';
import 'package:user/app/controller/booking_controller.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => BookingController(parser: Get.find()));
  }
}


import 'package:user/app/backend/api/api.dart';
import 'package:user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:user/app/util/constant.dart';

class WebProductPaymentParse {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  WebProductPaymentParse({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> createAppoinments(var param) async {
    return await apiService.postPrivate(AppConstants.productCreate, param, sharedPreferencesManager.getString('token') ?? '');
  }

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  Future<Response> verifyPurchase(var payKey) async {
    return await apiService.getPrivate(AppConstants.verifyRazorPayments + payKey, sharedPreferencesManager.getString('token') ?? '');
  }

  String getName() {
    String firstName = sharedPreferencesManager.getString('first_name') ?? '';
    String lastName = sharedPreferencesManager.getString('last_name') ?? '';
    return '$firstName $lastName';
  }

  String getEmail() {
    return sharedPreferencesManager.getString('email') ?? '';
  }

  String getSupportEmail() {
    return sharedPreferencesManager.getString('supportEmail') ?? '';
  }

  String getSupportPhone() {
    return sharedPreferencesManager.getString('supportPhone') ?? '';
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/selected_services_controller.dart';
import 'package:user/app/controller/service_cart_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class SelectedServicesScreen extends StatefulWidget {
  const SelectedServicesScreen({super.key});

  @override
  State<SelectedServicesScreen> createState() => _SelectedServicesScreenState();
}

class _SelectedServicesScreenState extends State<SelectedServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectedServicesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.whiteColor,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text(value.selectedServiceName, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
            leading: IconButton(onPressed: () => value.onBack(), icon: const Icon(Icons.close), color: ThemeProvider.whiteColor),
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: value.servicesList.length,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, i) => Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ThemeProvider.whiteColor,
                                  boxShadow: const [BoxShadow(color: ThemeProvider.greyColor, blurRadius: 5.0, offset: Offset(0.7, 2.0))],
                                ),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: SizedBox.fromSize(
                                            size: const Size.fromRadius(40),
                                            child: FadeInImage(
                                              image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.servicesList[i].cover}'),
                                              placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                              imageErrorBuilder: (context, error, stackTrace) {
                                                return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                              },
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                            height: 20,
                                            width: 40,
                                            decoration: BoxDecoration(color: ThemeProvider.blackColor.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                                            child: Center(
                                              child: Text(
                                                '${value.servicesList[i].discount}  %',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 10, color: ThemeProvider.whiteColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Positioned(
                                            right: 20,
                                            top: 10,
                                            child: Checkbox(
                                              checkColor: Colors.white,
                                              activeColor: ThemeProvider.appColor,
                                              value: value.servicesList[i].isChecked,
                                              onChanged: (status) => value.updateServiceStatusInCart(i, status as bool),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(value.servicesList[i].name.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'bold', fontSize: 14)),
                                              const SizedBox(height: 2),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: Get.find<SelectedServicesController>().currencySide == 'left'
                                                          ? '${Get.find<SelectedServicesController>().currencySymbol}  ${value.servicesList[i].price}'
                                                          : '  ${value.servicesList[i].price}${Get.find<SelectedServicesController>().currencySymbol}',
                                                      style: const TextStyle(fontSize: 12, color: ThemeProvider.greyColor, decoration: TextDecoration.lineThrough),
                                                    ),
                                                    TextSpan(
                                                      text: Get.find<SelectedServicesController>().currencySide == 'left'
                                                          ? '${Get.find<SelectedServicesController>().currencySymbol}  ${value.servicesList[i].off}'
                                                          : '  ${value.servicesList[i].off}${Get.find<SelectedServicesController>().currencySymbol}',
                                                      style: const TextStyle(fontSize: 12, color: ThemeProvider.greenColor, fontFamily: 'bold'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                value.servicesList[i].duration.toString() + ' min'.tr,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(color: ThemeProvider.greyColor, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: Get.find<ServiceCartController>().totalItemsInCart > 0
              ? SizedBox(
                  height: 70,
                  child: InkWell(
                    onTap: () => value.onCheckout(),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            value.currencySide == 'left'
                                ? '${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${value.currencySymbol} ${Get.find<ServiceCartController>().totalPrice}'
                                : ' ${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${Get.find<ServiceCartController>().totalPrice}${value.currencySymbol}',
                            style: const TextStyle(color: ThemeProvider.whiteColor),
                          ),
                          Text('Book Services'.tr, style: const TextStyle(color: ThemeProvider.whiteColor)),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        );
      },
    );
  }
}

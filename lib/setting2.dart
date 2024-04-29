/*import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:price_scanner_app/blocs/setting.bloc.dart';
import 'package:price_scanner_app/services/naviagation.service.dart';
import 'vendor/resize/resize.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/dropdown.text.widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController _deviceNameController = TextEditingController();
  // bool _isArabic = false;
  SettingsBlocPage bloc = SettingsBlocPage();
  @override
  void initState() {
// TODO: implement initState
    super.initState();
    _initSystem();
    if (!GetIt.instance.isRegistered<NavigationService>()) {
      GetIt.instance
          .registerSingleton<NavigationService>(NavigationService(context));
    }
  }

  _initSystem() async {
    // final prefs = await SharedPreferences.getInstance();
    // if (prefs.containsKey('ipaddress')) {
    //   widget.bloc.selectedIP = prefs.getString('ipaddress').toString();
    //   if (prefs.containsKey('deviceName')) {
    //     widget.bloc.deviceName = prefs.getString('deviceName').toString();
    //     if (prefs.containsKey('deviceId')) {
    //       widget.bloc.deviceId = prefs.getString('deviceId').toString();
    //       widget.bloc.goToHomePage();
    //     }
    //   }
    // }
  }

  void _showPopUpMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message'),
          content: Text(message),
          actions: [
            ElevatedButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 50.h),
              child: Container(
                width: 500.w,
                height: 300.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15.r)),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 8.h),
                        child: Text(
                          'Connection',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
/*
                       Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 8.h),
                        child: SizedBox(
                          width: 500.w,
                          height: 50.h,
                          child: DropdownTextField(
                            options: bloc.ipAddresses,
                            placeHolder: "IP address",
                            onSelect: (selectedIp) {
                              bloc.setIP(selectedIp);
                            },
                          ),
                        ),
                      ),
*/
                      // Container(
                      //   margin: const EdgeInsets.all(5.0),
                      //   child: TextField(
                      //     decoration: InputDecoration(
                      //       contentPadding: const EdgeInsets.symmetric(
                      //           vertical: 16.0, horizontal: 16.0),
                      //       labelText: 'Settingoooo',
                      //       labelStyle: const TextStyle(
                      //         color: Colors.black,
                      //       ),
                      //       hintStyle: const TextStyle(color: Colors.grey),
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(8.0),
                      //         borderSide: const BorderSide(
                      //           color: Colors.black,
                      //           width: 2.0,
                      //         ),
                      //       ),
                      //       focusedBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(8.0),
                      //         borderSide: const BorderSide(
                      //           color: Colors.black,
                      //           width: 2.0,
                      //         ),
                      //       ),
                      //     ),
                      //     controller: _deviceNameController,
                      //   ),
                      // ),
                      Align(
                        widthFactor: 5,
                        heightFactor: 2,
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          child: ElevatedButton(
                            onPressed: () {
                              bloc.connect();
                            },
                            child: SizedBox(
                                width: 70,
                                height: 50,
                                child: Center(
                                    child: const Text(
                                  "connect",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ))),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/
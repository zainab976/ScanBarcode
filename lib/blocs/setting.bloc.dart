import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:price_scanner_app/blocs/base.bloc.dart';
import 'package:price_scanner_app/blocs/item.bloc.dart';
import 'package:price_scanner_app/blocs/property.dart';
import 'package:price_scanner_app/services/naviagation.service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

import '../../vendor/network_analyzer.dart';

class SettingsBlocPage implements BlocBase {
  Property<List<String>> ipAddresses = Property([]);
  Property<String> errMsg = Property("");

  late String deviceId;
  late String deviceName = '';
  late String selectedIP = '';

  SettingsBlocPage() {
     _load();
  }

  _load() async {
    if (!await _initSystem()) {
      getIpAddress();
      _getDeviceId();
     }
  }

  ///return true if connection availbale
  Future<bool> _initSystem() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('ipaddress')) {
      selectedIP = prefs.getString('ipaddress').toString();

        if (prefs.containsKey('deviceId')) {
          deviceId = prefs.getString('deviceId').toString();
          //   _goToHomePage();
          goToItemPage();
          return true;
        }
      
    }

    return false;
  }

  getIpAddress() async {
    try {
      ipAddresses.value = [];
      int port = 5600;
      //List<String> addresses = ["192.168.1.2"];
      List<String> addresses = [
        "10.2.2.2"
      ];
      for (var element in await NetworkInterface.list()) {
        for (var address in element.addresses) {
          addresses.add(address.address);
        }
      }

      for (var element in addresses) {
        try {
          String subnet = element.substring(0, element.lastIndexOf("."));

          final stream = NetworkAnalyzer.discover2(subnet, port);
          stream.listen((NetworkAddress addr) {
            if (addr.exists) {
              ipAddresses.value.add(addr.ip.toString());
              ipAddresses.sink(ipAddresses.value);
            }
          });
        } catch (e) {}
      }
    } catch (e) {
      print(e.toString());
    }
  }

  setSystemVars() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (selectedIP != '') {
      await prefs.setString('ipaddress', selectedIP);
    }

    if (deviceId != '') {
      await prefs.setString('deviceId', deviceId);
    }
  }

  _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id.toString();
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsDeviceInfo = await deviceInfo.windowsInfo;
      deviceId = windowsDeviceInfo.deviceId.toString();
    }
  }

//  _goToHomePage() {
//     GetIt.instance
//         .get<NavigationService>()
//         .goToHomePage(HomeBlocPage(deviceId, selectedIP, deviceName));
//   }
  goToItemPage() {
    GetIt.instance.get<NavigationService>().goToItemPage(ItemPageBloc(selectedIP, deviceId));
  }

  void connect() async {
    RegExp regExp = RegExp('^(?:[0-9]{1,3}\.){3}[0-9]{1,3}');
    if (selectedIP != regExp.stringMatch(selectedIP)) {
      errMsg.sink("Not valid IP");
      return;
    }
    await setSystemVars();
    // _goToHomePage();
    goToItemPage();
  }

  connectToCustom(String customIp) async {
    try {
      selectedIP = customIp;
      connect();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    ipAddresses.dispose();
  }
}

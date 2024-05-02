import 'dart:convert';
//import 'dart:ffi';

import 'package:price_scanner_app/blocs/base.bloc.dart';
import 'package:price_scanner_app/blocs/property.dart';
import 'package:price_scanner_app/models/Preferences.dart';
import 'package:price_scanner_app/models/device.dart';
import 'package:price_scanner_app/models/product.dart';
import 'package:price_scanner_app/vendor/socket.client.dart';

class ItemPageBloc implements BlocBase {
  String ipAddress;
  String deviceId;
  Product? product;
  Property<bool> connectionStatus = Property(false);
  Property<Preferences?> preferences = Property(null);

  late SocketClient socket;
  ItemPageBloc(this.ipAddress, this.deviceId) {
    socket = SocketClient("ws://$ipAddress:5600");
    socket.connect();
    socket.onConnect = () async {
      print("connected $ipAddress");
      var res = await socket.emitWithAck("Register", Device(deviceId: deviceId, deviceType: "PriceChecker", deviceName: 'Price Checker').toMap());

      res = await socket.emitWithAck("getPreference", {});

      print(res);
      preferences.sink(Preferences.fromMap(json.decode(res)));
    };

    socket.onConnectionChange = (connection) {
      connectionStatus.sink(connection);
    };
  }

  Future<bool> scanBarcode(String barcode) async {
    print(barcode);
    if (barcode.isEmpty) return false;
    String data = await socket.emitWithAck(
        "scanBarcode",
        json.encode({
          "barcode": barcode
        }));
    Map<String, dynamic> map = json.decode(data);
    if (map['found'] == true) {
      product = Product.fromMap(map['product']);
    } else {
      product = null;
    }
    return true;
  }

  String convertToCurrency(double num) {
    if (preferences.value != null) {
      String currencySymbol = preferences.value!.settings.currencySymbol;
      int afterDecimal = preferences.value!.settings.afterDecimal;
      return "$currencySymbol ${num.toStringAsFixed(afterDecimal)}";
    } else {
      return num.toString();
    }
  }

  String convertToNumber(double num) {
    if (preferences.value != null) {
      int afterDecimal = preferences.value!.settings.afterDecimal;
      return num.toStringAsFixed(afterDecimal);
    } else {
      return num.toString();
    }
  }

  @override
  void dispose() {
    connectionStatus.dispose();
    preferences.dispose();
  }
}

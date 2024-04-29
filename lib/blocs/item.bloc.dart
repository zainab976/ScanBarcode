import 'dart:convert';

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
    socket = SocketClient("ws://${ipAddress}:5600");
    socket.connect();
    socket.onConnect = () async {
      print("connected");
      var res = await socket.emitWithAck(
          "Register",
          Device(
                  deviceId: deviceId,
                  deviceType: "PriceChecker",
                  deviceName: 'Price Checker')
              .toMap());

      res = await socket.emitWithAck("getPreference", {});

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
        "scanBarcode", json.encode({"barcode": barcode}));
    Map<String, dynamic> map = json.decode(data);
    if (map['found'] == true) {
      product = Product.fromMap(map['product']);
    } else {
      product = null;
    }
    return true;
  }

  @override
  void dispose() {
    connectionStatus.dispose();
    preferences.dispose();
  }
}

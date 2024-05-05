import 'dart:async';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:price_scanner_app/blocs/item.bloc.dart';
import 'package:price_scanner_app/models/product.dart';
import 'package:price_scanner_app/services/naviagation.service.dart';
import 'package:price_scanner_app/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'vendor/resize/resize.dart';

class itemDetails extends StatefulWidget {
  ItemPageBloc bloc;
  itemDetails({super.key, required this.bloc});

  @override
  State<itemDetails> createState() => _itemDetailsState();
}

class _itemDetailsState extends State<itemDetails> {
  bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 500;

  bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 500;

  Timer? timer;
  String barcode = "";

  bool itemView = false;
  @override
  void initState() {
    super.initState();
  }

  @override 

  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      
        initialData: true,
        stream: widget.bloc.connectionStatus.stream,
        builder: (context, snapshot) {
          if (snapshot.data!) {
            bool isItemDetailsShown;
            return RawKeyboardListener(
              focusNode: FocusNode(),
              autofocus: true,
              onKey: (event) async {
                if (event.logicalKey.keyLabel == "Enter") {
                  String tempBarcode = barcode;
                  barcode = "";
                  if (await widget.bloc.scanBarcode(tempBarcode)) {
                    setState(() {
                      itemView = true;
                    });
                    if (timer != null) timer!.cancel();
                    timer = Timer(
                        const Duration(
                            seconds: 10), //the wanted duration for the timer
                        () {
                      setState(() {
                        itemView = false;
                      });
                    });
                  }
                } else {
                  if (event.character != null) {
                    barcode += event.character!;
                  }
                }
              },
              child: Scaffold(
                backgroundColor: const Color.fromARGB(255, 2, 59, 112),
                appBar: !itemView
                    ? AppBar(
                        // Add the desired properties to the AppBar
                        backgroundColor: Colors.white,
                        toolbarHeight: (MediaQuery.of(context).size.width * 0.2).clamp(0, 135),
                        leading: Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                          child: StreamBuilder(
                            stream: widget.bloc.preferences.stream,
                            builder: (context, snapshot) {
                              if (widget.bloc.preferences.value == null) {
                                return const SizedBox();
                              }
                              String logo = widget.bloc.preferences.value!.logo;
                              try {
                                if (logo == "") {
                                  return const SizedBox();
                                } else {
                                  logo = logo.replaceFirst(/*"data:image/jpg;base64,"*/ "", "");
                                  return Image.memory(
                                    base64Decode(logo),
                                    width: MediaQuery.of(context).size.width * 0.4,
                                  );
                                }
                              } catch (e) {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                        leadingWidth: MediaQuery.of(context).size.width * 0.2,
                        title: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: StreamBuilder(
                              stream: widget.bloc.preferences.stream,
                              builder: (context, snapshot) {
                            return Row(
  children: [
    Expanded(
      child: Center(
        child: Text(
          widget.bloc.preferences.value == null ? "" : widget.bloc.preferences.value!.name,
          style: TextStyle(
            color: Color.fromARGB(255, 2, 59, 112),
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ],
);
                              },
                            ),
                          ),
                        ),
                        actions: [
                         
                    Padding(
  padding: const EdgeInsets.all(0.0),
  child: FloatingActionButton.extended(
    label: const Text('').tr(),
    backgroundColor: Colors.white,
    elevation: 0, // Set elevation to 0 to remove the shadow
    onPressed: () async {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove("ipaddress");
      prefs.remove("deviceId");
      GetIt.instance.unregister<NavigationService>();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const SettingPage();
          },
        ),
      );
    },
  ),
), 
                          Padding(
                            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                            child: Image.asset(
                              'assets/invo_image.png',
                              width: MediaQuery.of(context).size.width * 0.2,
                            ),
                          ),
                        ],
                      )
                    : null,

                //        body: itemView ? itemWidget() : scanWidget(),
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: itemView ? itemWidget() : scanWidget(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            // if no connection show
            return Scaffold(
                backgroundColor: const Color.fromARGB(255, 2, 59, 112),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "No Connection".tr(),
                          style: TextStyle(
                            fontSize: 57.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      FloatingActionButton.extended(
                        label: const Text('GO Back').tr(),
                        backgroundColor: const Color.fromARGB(255, 3, 135, 124),
                        icon: const Icon(
                          Icons.navigate_before, //arrow_back //arrow_back //navigate_before
                          size: 24.0,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const SettingPage();
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ));
          }
        });
  }

  Widget itemWidget() {
    if (widget.bloc.product == null) {
      return Center(
        child: Text(
          "Item Not Found".tr(),
          style: TextStyle(
            fontSize: 120.sp,
            color: Colors.white,
          ),
        ),
      );
    }

    Product product = widget.bloc.product!;

    List<Widget> widgets = [];
    if (isDesktop(context)) {
      widgets = [
        itemImage(product),
        itemDetails(product)
      ];
    } else {
      widgets = [
        itemDetails(product)
      ];
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }

  Widget itemDetailsWithImage(Product product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        itemImage(product),
        itemDetails(product),
      ],
    );
  }

  Widget itemImage(Product product) {
    Widget temp = Card(
      color: Colors.white,
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Text(
          "No Image".tr(),
          style: TextStyle(
            fontSize: 63.sp,
            color: Colors.black,
          ),
        ),
      ),
    );

    RegExp _base64 = RegExp(r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$');
    if (product.defaultImage != "") {
      if (_base64.hasMatch(product.defaultImage)) {
        temp = Card(
          elevation: 12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Image(
              image: MemoryImage(base64Decode(product.defaultImage)),
              fit: BoxFit.contain, // Adjust the image size to fit within the available space
            ),
          ),
        );
      }
    }

    double screenHeight = MediaQuery.of(context).size.height;
    double desiredHeight = 633;
    double height = desiredHeight;

    if (desiredHeight > screenHeight) {
      height = screenHeight;
    }

    return SizedBox(
      height: height,
      width: height, // Set the width to match the height for a square image
      child: temp,
    );
  }

  Widget itemDetails(Product product) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 32.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                product.name,
                style: TextStyle(
                  fontSize: 50.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8), // Adjust the height as needed
              Text(
                "price".tr(),
                style: TextStyle(
                  fontSize: 34.sp,
                  color: Colors.white,
                ),
              ),
              Text(
                widget.bloc.convertToCurrency(product.price),
                style: TextStyle(
                  fontSize: 70.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget scanWidget() {
    double logicWidth = 600;
    double logicHeight = 600;
    return SizedBox.expand(
        child: Container(
            // color: Colors.blueGrey,
            child: FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.center,
                child: SizedBox(
                  width: logicWidth,
                  height: logicHeight,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 22.h,
                      ),
                      Container(
                        // padding: EdgeInsets.only(bottom: 43.h),
                        height: 100.h,
                        child: Text(
                          "Scan here".tr(),
                          style: TextStyle(
                            fontSize: 52.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 250,
                        child: Image(
                          image: AssetImage(
                            'assets/BarcodeScanner.png',
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 32.h,
                      ),
                      // ignore: prefer_const_constructors
                      SizedBox(
                        width: 180,
                        height: 90,
                        child: const Image(image: AssetImage('assets/arrow-down.png')),
                      ),
                    ],
                  ),
                ))));
  }
}


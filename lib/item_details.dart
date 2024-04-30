import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:price_scanner_app/blocs/item.bloc.dart';
import 'package:price_scanner_app/models/product.dart';
import 'package:price_scanner_app/setting.dart';
import 'vendor/resize/resize.dart';
import 'setting2.dart';

class itemDetails extends StatefulWidget {
  ItemPageBloc bloc;
  itemDetails({super.key, required this.bloc});

  @override
  State<itemDetails> createState() => _itemDetailsState();
}

class _itemDetailsState extends State<itemDetails> {
  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 500;

  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 500;

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
                            seconds: 30), //the wanted duration for the timer
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
  appBar: AppBar(
    backgroundColor: Colors.white,
    toolbarHeight: 135,
    leading: Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      child: StreamBuilder(
        stream: widget.bloc.preferences.stream,
        builder: (context, snapshot) {
          if (widget.bloc.preferences.value == null) {
            return const SizedBox();
          }
          String logo = widget.bloc.preferences.value!.logo;
          try {
            if (logo == "") {
              // add invo log if no logo available
              return const SizedBox();
            } else {
              logo = logo.replaceFirst(
                  /*"data:image/jpg;base64,"*/ "", "");
              return Image.memory(
                base64Decode(logo),
              );
            }
          } catch (e) {
            return const SizedBox();
          }
        },
      ),
    ),
    leadingWidth: 160,
    title: Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 43.0),
        child: StreamBuilder(
          stream: widget.bloc.preferences.stream,
          builder: (context, snapshot) {
            return Flexible(
              child: Text(
                widget.bloc.preferences.value == null
                    ? ""
                    : widget.bloc.preferences.value!.name,
                style: const TextStyle(
                  color: Color.fromARGB(255, 2, 59, 112),
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(21.0),
        child: Image.asset(
          'assets/invo_image.png',
          width: 160,
        ),
      ),
    ],
  ),

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
            return Scaffold(
                backgroundColor: const Color.fromARGB(255, 2, 59, 112),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "No Connection",
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
                        label: const Text('GO Back'),
                        backgroundColor: const Color.fromARGB(255, 3, 135, 124),
                        icon: const Icon(
                          Icons
                              .navigate_before, //arrow_back //arrow_back //navigate_before
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
          "Item Not Found",
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
      widgets = [itemImage(product), itemDetails(product)];
    } else {
      widgets = [itemDetails(product)];
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }

  Widget itemImage(Product product) {
    Widget temp = Card(
      color: Colors.white, //.fromARGB(255, 140, 140, 138),
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Text("No Image",
            style: TextStyle(
              fontSize: 63.sp,
            )),
      ),
    );

    RegExp _base64 = RegExp(
        r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$');
    if (product.defaultImage != "") {
      if (_base64.hasMatch(product.defaultImage)) {
        temp = Card(
          elevation: 12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Image(
              image: MemoryImage(base64Decode(product.defaultImage)),
            ),
          ),
        );
      }
    }

    return Expanded(
      flex: 2,
      child: Container(
        color: const Color.fromARGB(255, 204, 239, 245),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(43.0),
            child: temp,
          ),
        ),
      ),
    );
  }

  Widget itemDetails(Product product) {
  return Container(
    width: 520,
    color: Colors.blue[900],
    child: Padding(
      padding: EdgeInsets.only(left: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 180 * MediaQuery.of(context).size.height / 896,
          ),
          SizedBox(
            child: Text(
              product.name,
              style: TextStyle(
                fontSize: 70 * MediaQuery.of(context).size.height / 896,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 75 * MediaQuery.of(context).size.height / 896,
          ),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "price",
                  style: TextStyle(
                    fontSize: 34 * MediaQuery.of(context).size.height / 896,
                    color: Colors.white,
                  ),
                ),
                Text(
                  product.price.toString(),
                  style: TextStyle(
                    fontSize: 70 * MediaQuery.of(context).size.height / 896,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget scanWidget() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.only(top: 120.0),
      child: SizedBox(
        height: 500,
        child: Column(
          children: [
            SizedBox(
              height: 12.h,
            ),
            Container(
              height: 100.h,
              child: Text(
                "Scan here",
                style: TextStyle(
                  fontSize: 52.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 32.h,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Image(
                    image: AssetImage('assets/BarcodeScanner.png'),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 32.h,
            ),
            SizedBox(
              width: 180,
              height: 90,
              child: Image(image: AssetImage('assets/arrow-down.png')),
            ),
          ],
        ),
      ),
    ),
  );
}
}

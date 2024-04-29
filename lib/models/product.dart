class Product {
  String id;
  String name;
  String type;
  double price;
  double onHand;
  String barcode;
  String defaultImage = "";
  bool isSelected = false;
  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.barcode,
    required this.onHand,
    required this.price,
    this.defaultImage = "",
  });

  String get available {
    if (type == "Service" ||
        type == "menuItem" ||
        type == "Package" ||
        type == "menuSelection") {
      return "";
    }
    return onHand.toString();
  }

  factory Product.fromMap(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'].toString(),
        barcode: json['barcode'] ?? "",
        price: double.parse((json['price'] ?? json['defaultPrice']).toString()),
        onHand: json['onHand'] == null
            ? 0
            : double.parse(json['onHand'].toString()),
        type: json['type'].toString(),
        defaultImage: json['defaultImage'] ?? "");
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'barcode': barcode,
      'price': price,
      'onHand': onHand,
      'type': type,
      'defaultImage': defaultImage,
    };
    return map;
  }
}

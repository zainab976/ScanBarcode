class Preferences {
  String name;
  String country;
  String logo;
  double smallestCurrency;
  String roundingType; //normal negative postive

  PreferenceSetting settings;
  Preferences({
    required this.name,
    required this.country,
    required this.smallestCurrency,
    required this.roundingType,
    required this.logo,
    required this.settings,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
        name: json['name'].toString(),
        country: json['country'].toString(),
        smallestCurrency: json['smallestCurrency'] == null
            ? 0
            : double.parse(json['smallestCurrency'].toString()),
        roundingType: json['roundingType'] ?? "normal",
        logo: json['logo'],
        settings: PreferenceSetting.fromJson(json['settings']));
  }

  Map<String, Object?> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'country': country,
      'logo': logo,
      'smallestCurrency': smallestCurrency,
      'roundingType': roundingType,
      'settings': settings.toMap()
    };
    return map;
  }

  factory Preferences.fromMap(Map<dynamic, dynamic> map) {
    return Preferences(
      name: map['name'].toString(),
      country: map['country'].toString(),
      smallestCurrency: map['smallestCurrency'] ?? 0,
      roundingType: map['roundingType'] ?? "normal",
      logo: map['logo'],
      settings: PreferenceSetting(
        countryCode: "973",
        afterDecimal: 2,
        currencySymbol: "\$",
        phoneLength: 8,
        phoneRegExp: "",
        addressFormat: [],
      ),
    );
  }
}

class PreferenceSetting {
  String countryCode;
  int afterDecimal;
  String currencySymbol;
  String phoneRegExp;
  int phoneLength;
  List<AddressFormat> addressFormat;

  PreferenceSetting(
      {required this.countryCode,
      required this.afterDecimal,
      required this.currencySymbol,
      required this.phoneLength,
      required this.phoneRegExp,
      required this.addressFormat});

  factory PreferenceSetting.fromJson(Map<String, dynamic> json) {
    List<AddressFormat> addressFormats = [];
    for (var element in json['addressFormat']) {
      addressFormats.add(AddressFormat.fromJson(element));
    }

    return PreferenceSetting(
      countryCode: json['countryCode'] ?? "973",
      afterDecimal: json['afterDecimal'] ?? 3,
      currencySymbol: json['currencySymbol'] ?? "BHD",
      phoneLength: json['phoneLength'] ?? 8,
      phoneRegExp: json['phoneRegExp'] ?? "",
      addressFormat: addressFormats,
    );
  }

  Map<String, Object?> toMap() {
    List<Map<String, dynamic>> formats = [];
    for (var element in addressFormat) {
      formats.add(element.toMap());
    }

    var map = <String, dynamic>{
      'afterDecimal': afterDecimal,
      'phoneLength': phoneLength,
      'countryCode': countryCode,
      'currencySymbol': currencySymbol,
      'phoneRegExp': phoneRegExp,
      'addressFormat': formats,
    };
    return map;
  }

  factory PreferenceSetting.fromMap(Map<dynamic, dynamic> map) {
    List<AddressFormat> addressFormats = [];
    if (map['addressFormat'] != null) {
      for (var element in map['addressFormat']) {
        addressFormats.add(AddressFormat.fromJson(element));
      }
    }

    return PreferenceSetting(
      countryCode: map['countryCode'].toString(),
      afterDecimal: map['afterDecimal'],
      currencySymbol: map['currencySymbol'] ?? "",
      phoneLength: map['phoneLength'] ?? 8,
      phoneRegExp: map['phoneRegExp'] ?? "",
      addressFormat: addressFormats,
    );
  }
}

class AddressFormat {
  String key = "";
  String title = "";
  bool isRequired = false;

  AddressFormat();
  factory AddressFormat.fromJson(Map<String, dynamic> json) {
    AddressFormat format = AddressFormat();
    format.key = json['key'] ?? "";
    format.title = json['title'] ?? "";
    format.isRequired = json['isRequired'] ?? false;
    return format;
  }

  Map<String, Object?> toMap() {
    var map = <String, dynamic>{
      'key': key,
      'title': title,
      'isRequired': isRequired,
    };
    return map;
  }

  factory AddressFormat.fromMap(Map<dynamic, dynamic> map) {
    AddressFormat format = AddressFormat();
    format.key = map['key'] ?? "";
    format.title = map['title'] ?? "";
    format.isRequired = map['isRequired'] ?? false;
    return format;
  }
}

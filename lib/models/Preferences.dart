import 'dart:convert';

class Preferences {
  String name;
  String country;
  String logo;
  double smallestCurrency;
  String roundingType; //normal negative postive

  PreferenceSetting settings;
  PreferenceOptions options;
  DeliveryAddresses? deliveryAddresses;
  List<String> voidReasons = [];
  List<WorkingHours> workingHours = [];
  String branchName;
  String branchAddress;
  BranchLocation? branchLocation;
  String? phoneNumber;
  String? vatNumber;
  bool isInclusiveTax;
  String slug;
  String branchId;
  PrintingOptions printingOptions;
  InvoiceOptions invoiceOptions;
  List<Aggregator> aggregators = [];

  Preferences({required this.name, required this.country, required this.smallestCurrency, required this.roundingType, required this.logo, required this.settings, required this.options, required this.voidReasons, required this.workingHours, required this.branchName, required this.branchAddress, required this.branchLocation, required this.phoneNumber, required this.vatNumber, required this.isInclusiveTax, required this.slug, required this.branchId, required this.printingOptions, required this.invoiceOptions, required this.aggregators});

  factory Preferences.fromJson(Map<String, dynamic> json, {String branchId = ""}) {
    List<WorkingHours> schedules = [];

    if (json['workingHours'] != null) {
      json['workingHours'].forEach((key, value) {
        List<TimePeriod> timePeriods = [];
        TimePeriod timePeriod;
        for (var element in value) {
          timePeriod = TimePeriod.fromMap(element);
          timePeriods.add(timePeriod);
        }
        schedules.add(WorkingHours(key, timePeriods));
      });
    }

    List<String> _voidReasons = [];

    if (json['voidReasons'] != null) {
      try {
        for (var element in json['voidReasons']) {
          _voidReasons.add(element.toString());
        }
      } catch (e) {}
    }

    List<Aggregator> _aggregators = [];

    if (json['aggregators'] != null) {
      try {
        for (var element in json['aggregators']) {
          _aggregators.add(Aggregator.fromJson(element));
        }
      } catch (e) {}
    }

    PrintingOptions printingOptions = PrintingOptions(printReceiptOnPaid: true, printRecieptOnSent: true, printRecieptOnVoid: true, numberOfRecieptWhenPaid: 1, numberOfReceiptWhenSent: 1);
    if (json['printingOptions'] != null && json['printingOptions'] != "") {
      // dynamic address = json.decode(map['options'].toString());
      printingOptions = PrintingOptions.fromJson(json['printingOptions']);
    }

    InvoiceOptions invoiceOptions = InvoiceOptions(note: "", term: "");
    if (json['invoiceOptions'] != null && json['invoiceOptions'] != "") {
      // dynamic address = json.decode(map['options'].toString());
      invoiceOptions = InvoiceOptions.fromJson(json['invoiceOptions']);
    }

    return Preferences(name: json['name'].toString(), country: json['country'].toString(), smallestCurrency: json['smallestCurrency'] == null ? 0 : double.parse(json['smallestCurrency'].toString()), roundingType: json['roundingType'] ?? "normal", logo: json['base64Image'] ?? "", settings: PreferenceSetting.fromJson(json['settings']), options: json['options'] == null ? PreferenceOptions() : PreferenceOptions.fromJson(json['options']), voidReasons: _voidReasons, workingHours: schedules, branchName: json['branchName'] ?? "", branchAddress: json['branchAddress'].toString(), branchLocation: json['branchLocation'] == null ? null : BranchLocation.fromMap(json['branchLocation']), phoneNumber: json['phoneNumber'], vatNumber: json['vatNumber'], isInclusiveTax: json['isInclusiveTax'], slug: json['slug'], branchId: json['branchId'] ?? branchId, printingOptions: printingOptions, invoiceOptions: invoiceOptions, aggregators: _aggregators);
  }

  Map<String, Object?> toMap() {
    Map<String, Object?> workingHoursMap = {};

    for (var x in workingHours) {
      List<Map<String, Object?>> timePeriodsMap = [];

      if (x.timePeriods.isNotEmpty)
        for (var element in x.timePeriods) {
          timePeriodsMap.add(element.toMap());
        }

      workingHoursMap.addAll(<String, dynamic>{
        x.day: timePeriodsMap,
      });
    }

    List<Map<String, Object?>> aggregatorsMap = [];
    for (var element in aggregators) {
      aggregatorsMap.add(element.toMap());
    }

    var map = <String, dynamic>{
      'name': name,
      'country': country,
      'logo': logo,
      'smallestCurrency': smallestCurrency,
      'roundingType': roundingType,
      'settings': json.encode(settings.toMap()),
      'options': json.encode(options.toMap()),
      'deliveryAddresses': deliveryAddresses == null ? null : json.encode(deliveryAddresses!.toMap()),
      'voidReasons': json.encode(voidReasons),
      'workingHours': json.encode(workingHoursMap),
      'branchName': branchName,
      'branchAddress': (branchAddress),
      'branchLocation': branchLocation != null ? json.encode(branchLocation!.toMap()) : null,
      'phoneNumber': phoneNumber == null ? null : phoneNumber,
      'vatNumber': vatNumber == null ? null : vatNumber,
      "isInclusiveTax": isInclusiveTax ? 1 : 0,
      "slug": slug,
      "branchId": branchId,
      "printingOptions": json.encode(printingOptions.toMap()),
      "invoiceOptions": json.encode(invoiceOptions.toMap()),
      'aggregators': json.encode(aggregatorsMap)
    };
    return map;
  }

  factory Preferences.fromMap(Map<dynamic, dynamic> map) {
    List<String> voidReasons = [];
    if (map['voidReasons'] != null) {
      for (var element in json.decode(map['voidReasons'])) {
        voidReasons.add(element.toString());
      }
    }

    List<Aggregator> aggregators = [];
    if (map['aggregators'] != null) {
      for (var element in json.decode(map['aggregators'])) {
        aggregators.add(Aggregator.fromMap(element));
      }
    }

    List<WorkingHours> schedules = [];
    // map['workingHours'].forEach((key, value) {
    //   List<TimePeriod> timePeriods = [];
    //   TimePeriod timePeriod;
    //   for (var element in value) {
    //     timePeriod = TimePeriod.fromMap(element);
    //     timePeriods.add(timePeriod);
    //   }
    //   schedules.add(Schedule(key, timePeriods));
    // });

    PrintingOptions printingOptions = PrintingOptions(printReceiptOnPaid: true, printRecieptOnSent: true, printRecieptOnVoid: true, numberOfRecieptWhenPaid: 1, numberOfReceiptWhenSent: 1);
    if (map['printingOptions'] != null && map['printingOptions'] != "") {
      dynamic options = json.decode(map['printingOptions']);
      printingOptions = PrintingOptions.fromMap(options);
    }

    InvoiceOptions invoiceOptions = InvoiceOptions(note: "", term: "");
    if (map['invoiceOptions'] != null && map['invoiceOptions'] != "") {
      dynamic options = json.decode(map['invoiceOptions']);
      invoiceOptions = InvoiceOptions.fromMap(options);
    }

    Preferences preferences = Preferences(
        name: map['name'].toString(),
        country: map['country'].toString(),
        smallestCurrency: map['smallestCurrency'] ?? 0,
        roundingType: map['roundingType'] ?? "normal",
        logo: map['logo'],
        voidReasons: voidReasons,
        settings: map['settings'] == null
            ? PreferenceSetting(
                countryCode: "973",
                afterDecimal: 2,
                currencySymbol: "\$",
                phoneLength: 8,
                phoneRegExp: "",
                addressFormat: [],
                cashValues: [],
              )
            : PreferenceSetting.fromMap(json.decode(map['settings'])),
        options: map['options'] == null
            ? PreferenceOptions()
            : PreferenceOptions.fromMap(
                json.decode(map['options']),
              ),
        workingHours: schedules,
        branchName: map['branchName'].toString(),
        branchAddress: map['branchAddress'].toString(),
        branchLocation: null,
        phoneNumber: map['phoneNumber'].toString(),
        vatNumber: map['vatNumber'].toString(),
        isInclusiveTax: map['isInclusiveTax'] == 1 ? true : false,
        slug: map['slug'].toString(),
        branchId: map['branchId'] ?? "",
        printingOptions: printingOptions,
        invoiceOptions: invoiceOptions,
        aggregators: aggregators);

    try {
      preferences.branchLocation = map['branchLocation'] == null
          ? null
          : BranchLocation.fromMap(
              json.decode(map['branchLocation']),
            );
    } catch (e) {}

    preferences.deliveryAddresses = map['deliveryAddresses'] == null
        ? null
        : DeliveryAddresses.fromMap(
            json.decode(map['deliveryAddresses']),
          );
    return preferences;
  }
}

class PreferenceSetting {
  String countryCode;
  int afterDecimal;
  String currencySymbol;
  String phoneRegExp;
  int phoneLength;
  List<AddressFormat> addressFormat;
  List<double> cashValues;

  PreferenceSetting({
    required this.countryCode,
    required this.afterDecimal,
    required this.currencySymbol,
    required this.phoneLength,
    required this.phoneRegExp,
    required this.addressFormat,
    required this.cashValues,
  });

  factory PreferenceSetting.fromJson(Map<String, dynamic> json) {
    List<AddressFormat> addressFormats = [];
    for (var element in json['addressFormat']) {
      addressFormats.add(AddressFormat.fromJson(element));
    }

    List<double> _cashValues = [];
    if (json['cashValues'] != null)
      for (var element in json['cashValues']) {
        _cashValues.add(double.parse(element.toString()));
      }

    return PreferenceSetting(
      countryCode: json['countryCode'] ?? "973",
      afterDecimal: json['afterDecimal'] ?? 3,
      currencySymbol: json['currencySymbol'] ?? "BHD",
      phoneLength: json['phoneLength'] ?? 8,
      phoneRegExp: json['phoneRegExp'] ?? "",
      addressFormat: addressFormats,
      cashValues: _cashValues,
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
      'cashValues': cashValues
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

    List<double> _cashValues = [];
    if (map['cashValues'] != null)
      for (var element in map['cashValues']) {
        _cashValues.add(double.parse(element.toString()));
      }

    return PreferenceSetting(
      countryCode: map['countryCode'].toString(),
      afterDecimal: map['afterDecimal'],
      currencySymbol: map['currencySymbol'] ?? "",
      phoneLength: map['phoneLength'] ?? 8,
      phoneRegExp: map['phoneRegExp'] ?? "",
      addressFormat: addressFormats,
      cashValues: _cashValues,
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

class PreferenceOptions {
  bool hideVoidedItem = false;
  bool noSaleWhenZero = false;
  bool disableHalfItem = false;
  bool addCustomerByMSR = false;
  int maxReferneceNumber = 99;
  bool voidedItemNeedExplanation = true;
  bool allowOnlyOneCashierPerTerminal = true;
  bool showPrice = true;
  bool showQty = true;

  PreferenceOptions();

  Map<String, Object?> toMap() {
    var map = <String, dynamic>{
      'hideVoidedItem': hideVoidedItem,
      'noSaleWhenZero': noSaleWhenZero,
      'disableHalfItem': disableHalfItem,
      'addCustomerByMSR': addCustomerByMSR,
      'voidedItemNeedExplanation': voidedItemNeedExplanation,
      'allowOnlyOneCashierPerTerminal': allowOnlyOneCashierPerTerminal,
      'maxReferneceNumber': maxReferneceNumber,
      'showPrice': showPrice,
      'showQty': showQty,
    };
    return map;
  }

  factory PreferenceOptions.fromMap(Map<dynamic, dynamic> map) {
    PreferenceOptions options = PreferenceOptions();
    options.hideVoidedItem = map['hideVoidedItem'] ?? false;
    options.noSaleWhenZero = map['noSaleWhenZero'] ?? false;
    options.disableHalfItem = map['disableHalfItem'] ?? false;
    options.addCustomerByMSR = map['addCustomerByMSR'] ?? false;
    options.voidedItemNeedExplanation = map['voidedItemNeedExplanation'] ?? false;
    options.allowOnlyOneCashierPerTerminal = map['allowOnlyOneCashierPerTerminal'] ?? false;
    options.showPrice = map['showPrice'] ?? false;
    options.showQty = map['showQty'] ?? false;

    try {
      if (int.tryParse(map['maxReferneceNumber'].toString()) != null)
        options.maxReferneceNumber = int.parse(map['maxReferneceNumber'].toString());
      else
        options.maxReferneceNumber = 99;
    } catch (e) {
      options.maxReferneceNumber = 99;
    }

    return options;
  }

  factory PreferenceOptions.fromJson(Map<String, dynamic> map) {
    PreferenceOptions options = PreferenceOptions();
    options.hideVoidedItem = map['hideVoidedItem'] ?? false;
    options.noSaleWhenZero = map['noSaleWhenZero'] ?? false;
    options.disableHalfItem = map['disableHalfItem'] ?? false;
    options.addCustomerByMSR = map['addCustomerByMSR'] ?? false;
    options.voidedItemNeedExplanation = map['voidedItemNeedExplanation'] ?? false;
    options.allowOnlyOneCashierPerTerminal = map['allowOnlyOneCashierPerTerminal'] ?? false;
    options.showPrice = map['showPrice'] ?? false;
    options.showQty = map['showQty'] ?? false;
    try {
      if (int.tryParse(map['maxReferneceNumber'].toString()) != null)
        options.maxReferneceNumber = int.parse(map['maxReferneceNumber'].toString());
      else
        options.maxReferneceNumber = 99;
    } catch (e) {
      options.maxReferneceNumber = 99;
    }
    return options;
  }
}

class DeliveryAddresses {
  String type;
  List<CoveredAddress> coveredAddresses = [];
  List<Address> list = []; // list of addresses
  DeliveryAddresses({this.type = ""});
  Map<String, Object?> toMap() {
    List<Map> _coveredAddresses = [];
    for (var element in coveredAddresses) {
      _coveredAddresses.add(element.toMap());
    }

    List<Map> _addresses = [];
    for (var element in list) {
      _addresses.add(element.toMap());
    }

    var map = <String, dynamic>{
      'type': this.type ?? "",
      'coveredAddresses': _coveredAddresses,
      'list': _addresses,
    };
    return map;
  }

  factory DeliveryAddresses.fromMap(Map<dynamic, dynamic> map) {
    List<Address> addresses = [];
    try {
      if (map['list'] != null) {
        for (var element in map['list']) {
          addresses.add(Address.fromMap(element));
        }
      }
    } catch (ex) {}

    List<CoveredAddress> _coveredAddresses = [];
    try {
      if (map['coveredAddresses'] != null) {
        for (var element in map['coveredAddresses']) {
          _coveredAddresses.add(CoveredAddress.fromMap(element));
        }
      }
    } catch (ex) {}

    DeliveryAddresses deliveryAddresses = DeliveryAddresses();
    deliveryAddresses.coveredAddresses = _coveredAddresses;
    deliveryAddresses.list = addresses;
    deliveryAddresses.type = map['type'] ?? "";
    return deliveryAddresses;
  }
}

class CoveredAddress {
  String address;
  double minimumOrder = 0;
  double deliveryCharge = 0;
  CoveredAddress({
    required this.address,
    this.minimumOrder = 0,
    this.deliveryCharge = 0,
  });

  Map<String, Object?> toMap() {
    var map = <String, dynamic>{
      'address': address,
      "minimumOrder": minimumOrder,
      "deliveryCharge": deliveryCharge,
    };
    return map;
  }

  factory CoveredAddress.fromMap(Map<dynamic, dynamic> map) {
    return CoveredAddress(
      address: map['address'] ?? "",
      minimumOrder: map['minimumOrder'] == null ? 0 : double.parse(map['minimumOrder'].toString()),
      deliveryCharge: map['deliveryCharge'] == null ? 0 : double.parse(map['deliveryCharge'].toString()),
    );
  }
}

class Address {
  String Governorate;
  String City;
  String Block;
  String Road;

  Address({
    required this.Governorate,
    required this.City,
    required this.Block,
    required this.Road,
  });

  Map<String, Object?> toMap() {
    var map = <String, dynamic>{
      'Governorate': Governorate,
      'City': City,
      'Block': Block,
      'Road': Road,
    };
    return map;
  }

  factory Address.fromMap(Map<dynamic, dynamic> map) {
    return Address(
      Governorate: map['Governorate'] ?? "",
      City: map['City'] ?? "",
      Block: map['Block'] ?? "",
      Road: map['Road'] ?? "",
    );
  }
}

class WorkingHours {
  String day;
  List<TimePeriod> timePeriods;

  WorkingHours(this.day, this.timePeriods);
}

class TimePeriod {
  String from;
  String to;

  TimePeriod(this.from, this.to);

  factory TimePeriod.fromMap(Map<String, dynamic> json) {
    return TimePeriod(json['from'], json['to']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'from': from,
      'to': to,
    };
    return map;
  }
}

class Sync {
  DateTime? lastUpdate;
  DateTime? lastPushEstimate;
  DateTime? lastPushInvoice;
  DateTime? lastPushCashier;
  DateTime? lastPushPayments;
  DateTime? lastPushCreditNote;
  DateTime? lastPushCreditNoteRefund;
  DateTime? lastWorkOrder;
  DateTime? lastPushPayout;

  Sync();

  Map<String, Object?> toMap() {
    var map = <String, dynamic>{
      'lastUpdate': lastUpdate == null ? null : lastUpdate!.millisecondsSinceEpoch,
      'lastPushEstimate': lastPushEstimate == null ? null : lastPushEstimate!.millisecondsSinceEpoch,
      'lastPushInvoice': lastPushInvoice == null ? null : lastPushInvoice!.millisecondsSinceEpoch,
      'lastPushCashier': lastPushCashier == null ? null : lastPushCashier!.millisecondsSinceEpoch,
      'lastPushPayments': lastPushPayments == null ? null : lastPushPayments!.millisecondsSinceEpoch,
      'lastPushCreditNote': lastPushCreditNote == null ? null : lastPushCreditNote!.millisecondsSinceEpoch,
      'lastPushCreditNoteRefund': lastPushCreditNoteRefund == null ? null : lastPushCreditNoteRefund!.millisecondsSinceEpoch,
      'lastWorkOrder': lastWorkOrder == null ? null : lastWorkOrder!.millisecondsSinceEpoch,
      'lastPushPayout': lastPushPayout == null ? null : lastPushPayout!.millisecondsSinceEpoch,
    };
    return map;
  }

  factory Sync.fromMap(Map<dynamic, dynamic> map) {
    Sync sync = Sync();
    sync.lastUpdate = map['lastUpdate'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['lastUpdate']);
    sync.lastPushEstimate = map['lastPushEstimate'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['lastPushEstimate']);
    sync.lastPushInvoice = map['lastPushInvoice'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['lastPushInvoice']);
    sync.lastPushCashier = map['lastPushCashier'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['lastPushCashier']);
    sync.lastPushPayments = map['lastPushPayments'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['lastPushPayments']);
    sync.lastPushCreditNote = map['lastPushCreditNote'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['lastPushCreditNote']);
    sync.lastPushCreditNoteRefund = map['lastPushCreditNoteRefund'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['lastPushCreditNoteRefund']);
    sync.lastWorkOrder = map['lastWorkOrder'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['lastWorkOrder']);
    sync.lastPushPayout = map['lastPushPayout'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['lastPushPayout']);

    return sync;
  }
}

class BranchLocation {
  String lat;
  String lng;

  BranchLocation(this.lat, this.lng);

  factory BranchLocation.fromMap(Map<String, dynamic> json) {
    try {
      return BranchLocation(json['lat'] ?? "", json['lng'] ?? "");
    } catch (e) {
      return BranchLocation("", "");
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'lat': lat,
      'lng': lng,
    };
    return map;
  }
}

class PrintingOptions {
  bool printReceiptOnPaid = true;
  bool printRecieptOnSent = true;
  bool printRecieptOnVoid = true;
  int numberOfRecieptWhenPaid = 1;
  int numberOfReceiptWhenSent = 1;

  PrintingOptions({required this.printReceiptOnPaid, required this.printRecieptOnSent, required this.printRecieptOnVoid, required this.numberOfRecieptWhenPaid, required this.numberOfReceiptWhenSent});

  factory PrintingOptions.fromJson(Map<String, dynamic> json) {
    print(json['printReceiptOnSent']);
    return PrintingOptions(printReceiptOnPaid: json['printReceiptOnPaid'] ?? false, printRecieptOnSent: json['printReceiptOnSent'] ?? false, printRecieptOnVoid: json['printReceiptOnVoid'] ?? false, numberOfRecieptWhenPaid: int.parse(json['numberOfReceiptWhenPaid'].toString()), numberOfReceiptWhenSent: int.parse(json['numberOfReceiptWhenSent'].toString()));
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'printReceiptOnPaid': printReceiptOnPaid ? 1 : 0,
      'printRecieptOnSent': printRecieptOnSent ? 1 : 0,
      'printRecieptOnVoid': printRecieptOnVoid ? 1 : 0,
      'numberOfRecieptWhenPaid': numberOfRecieptWhenPaid,
      'numberOfReceiptWhenSent': numberOfReceiptWhenSent
    };
    return map;
  }

  factory PrintingOptions.fromMap(Map<String, dynamic> map) {
    return PrintingOptions(printReceiptOnPaid: map['printReceiptOnPaid'] == 1 ? true : false, printRecieptOnSent: map['printRecieptOnSent'] == 1 ? true : false, printRecieptOnVoid: map['printRecieptOnVoid'] == 1 ? true : false, numberOfRecieptWhenPaid: int.parse(map['numberOfRecieptWhenPaid'].toString()), numberOfReceiptWhenSent: int.parse(map['numberOfReceiptWhenSent'].toString()));
  }
}

class InvoiceOptions {
  String note = "";
  String term = "";

  InvoiceOptions({required this.note, required this.term});

  factory InvoiceOptions.fromJson(Map<String, dynamic> json) {
    return InvoiceOptions(
      note: json['note'],
      term: json['term'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'note': note,
      'term': term,
    };
    return map;
  }

  factory InvoiceOptions.fromMap(Map<String, dynamic> map) {
    return InvoiceOptions(
      note: map['note'],
      term: map['term'],
    );
  }
}

class Aggregator {
  String id = "";
  String pluginName = "";

  Aggregator({required this.id, required this.pluginName});

  factory Aggregator.fromJson(Map<String, dynamic> json) {
    return Aggregator(
      id: json['id'],
      pluginName: json['pluginName'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'pluginName': pluginName,
    };
    return map;
  }

  factory Aggregator.fromMap(Map<String, dynamic> map) {
    return Aggregator(
      id: map['id'],
      pluginName: map['pluginName'],
    );
  }
}

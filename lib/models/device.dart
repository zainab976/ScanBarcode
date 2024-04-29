class Device {
  String deviceId;
  String deviceName;
  String deviceType;

  Device({
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
  });

  factory Device.fromJson(Map<String, dynamic> map) {
    return Device(
      deviceId: map['deviceId'],
      deviceName: map['deviceName'],
      deviceType: map['deviceType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "deviceId": deviceId,
      "deviceName": deviceName,
      "deviceType": deviceType
    };
  }
}

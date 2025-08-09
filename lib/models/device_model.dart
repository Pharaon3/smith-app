class DeviceModel {
  final String id;
  final String name;
  final String model;
  final String codename;
  final bool isSupported;
  final String? romUrl;
  final String? romVersion;
  final bool isConnected;
  final bool isUnlocked;
  final int batteryLevel;
  final String? serialNumber;

  const DeviceModel({
    required this.id,
    required this.name,
    required this.model,
    required this.codename,
    required this.isSupported,
    this.romUrl,
    this.romVersion,
    this.isConnected = false,
    this.isUnlocked = false,
    this.batteryLevel = 0,
    this.serialNumber,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      model: json['model'] ?? '',
      codename: json['codename'] ?? '',
      isSupported: json['isSupported'] ?? false,
      romUrl: json['romUrl'],
      romVersion: json['romVersion'],
      isConnected: json['isConnected'] ?? false,
      isUnlocked: json['isUnlocked'] ?? false,
      batteryLevel: json['batteryLevel'] ?? 0,
      serialNumber: json['serialNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'codename': codename,
      'isSupported': isSupported,
      'romUrl': romUrl,
      'romVersion': romVersion,
      'isConnected': isConnected,
      'isUnlocked': isUnlocked,
      'batteryLevel': batteryLevel,
      'serialNumber': serialNumber,
    };
  }

  DeviceModel copyWith({
    String? id,
    String? name,
    String? model,
    String? codename,
    bool? isSupported,
    String? romUrl,
    String? romVersion,
    bool? isConnected,
    bool? isUnlocked,
    int? batteryLevel,
    String? serialNumber,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      model: model ?? this.model,
      codename: codename ?? this.codename,
      isSupported: isSupported ?? this.isSupported,
      romUrl: romUrl ?? this.romUrl,
      romVersion: romVersion ?? this.romVersion,
      isConnected: isConnected ?? this.isConnected,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      serialNumber: serialNumber ?? this.serialNumber,
    );
  }

  @override
  String toString() {
    return 'DeviceModel(id: $id, name: $name, model: $model, codename: $codename, isSupported: $isSupported)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeviceModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Supported Pixel devices
class SupportedDevices {
  static const List<DeviceModel> devices = [
    DeviceModel(
      id: 'pixel_7a',
      name: 'Pixel 7a',
      model: 'G0DZQ',
      codename: 'akita',
      isSupported: true,
      romUrl: 'https://images.clean-slate.io/akita-factory-2025052900.zip',
      romVersion: '2025052900',
    ),
    DeviceModel(
      id: 'pixel_8',
      name: 'Pixel 8',
      model: 'G9BQD',
      codename: 'shiba',
      isSupported: true,
      romUrl: 'https://images.clean-slate.io/shiba-factory-2025052900.zip',
      romVersion: '2025052900',
    ),
    DeviceModel(
      id: 'pixel_8a',
      name: 'Pixel 8a',
      model: 'G6QUJ',
      codename: 'husky',
      isSupported: true,
      romUrl: 'https://images.clean-slate.io/husky-factory-2025052900.zip',
      romVersion: '2025052900',
    ),
    DeviceModel(
      id: 'pixel_8pro',
      name: 'Pixel 8 Pro',
      model: 'GC3VE',
      codename: 'komodo',
      isSupported: true,
      romUrl: 'https://images.clean-slate.io/komodo-factory-2025041400.zip',
      romVersion: '2025041400',
    ),
    DeviceModel(
      id: 'pixel_9a',
      name: 'Pixel 9a',
      model: 'G1AZG',
      codename: 'lynx',
      isSupported: true,
      romUrl: 'https://images.clean-slate.io/lynx-factory-2025052900.zip',
      romVersion: '2025052900',
    ),
  ];

  static DeviceModel? getDeviceByCodename(String codename) {
    try {
      return devices.firstWhere((device) => device.codename == codename);
    } catch (e) {
      return null;
    }
  }

  static DeviceModel? getDeviceByModel(String model) {
    try {
      return devices.firstWhere((device) => device.model == model);
    } catch (e) {
      return null;
    }
  }

  static bool isDeviceSupported(String codename) {
    return devices.any((device) => device.codename == codename);
  }
}

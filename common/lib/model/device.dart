import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:all_emojis/all_emojis.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'device.mapper.dart';

@MappableEnum(defaultValue: DeviceType.desktop)
enum DeviceType {
  mobile,
  desktop,
  web,
  headless,
  server,
}

/// Internal device model.
/// It gets not serialized.
@MappableClass()
class Device with DeviceMappable {
  final String ip;
  final String version;
  final int port;
  final bool https;
  final String fingerprint;
  final String alias;
  final String? deviceModel;
  final DeviceType deviceType;
  final bool download;

  String emojiFingerprint(Device other) {
    if (!this.https) {
      return '';
    }
    if (!other.https) {
      return '';
    }
    
    List<int> fingerprint = sha256.convert(utf8.encode(this.fingerprint + other.fingerprint)).bytes;

    print(fingerprint);
    print(this.fingerprint);

    List<int> bytes = fingerprint.sublist(0, 8);

    List<String> emojis = allEmojis.keys.toList();

    String out = '';
    for (int i = 0; i < bytes.length; i++) {
      out += emojis[bytes[i]];
    }

    return out;
  }

  const Device({
    required this.ip,
    required this.version,
    required this.port,
    required this.https,
    required this.fingerprint,
    required this.alias,
    required this.deviceModel,
    required this.deviceType,
    required this.download,
  });
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

///
/// Common Util is util class with many static methods
class CommonUtil {

  static String APP_ID = '6bd9bdcb293f4c929a19ab2fffdf2dbb';
  static String MAP_API_KEY = 'AIzaSyDiTjTMBetK-4k2oJMf4Eva_pWWOaXKMpA';

  static String CurrentCountry = "US";
  static const MethodChannel _channel =
  const MethodChannel('flutter_native_image');

  static final dateMonFormat = DateFormat("MM-dd");

  ///
  /// Validate email string
  static bool isValidEmail(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(email);
  }

  static bool isStringNotEmpty(String str) {
    return str != null && str.isNotEmpty;
  }

  static bool isStringEmpty(String str) {
    return str == null || str.isEmpty;
  }

  static bool isHttpUrl(String url) {
    return url.toLowerCase().startsWith('http');
  }

  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  //static String baseUrl = "http://18.214.102.144:3002/"; // old one
  static String baseUrl =
      "https://flutterbaseapi.cloveritservices.com/"; // new one

  static void checkFileAndDelete(File imageFile) async {
    bool val = await imageFile.exists();
    if (val != null && val == true) {
      imageFile.delete(recursive: true);
    }
  }

  static Future<File> compressImage(String fileName,
      {int percentage = 70,
        int quality = 70,
        int targetWidth = 0,
        int targetHeight = 0}) async {
    var file = await _channel.invokeMethod("compressImage", {
      'file': fileName,
      'quality': quality,
      'percentage': percentage,
      'targetWidth': targetWidth,
      'targetHeight': targetHeight
    });

    return new File(file);
  }



  static String stringFormat(String template, List replacements) {
    const String placeholderPattern = '(\{\{([a-zA-Z0-9]+)\}\})';
    var regExp = RegExp(placeholderPattern);
    for (var replacement in replacements) {
      template = template.replaceFirst(regExp, replacement.toString());
    }
    return template;
  }


}

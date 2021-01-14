import 'package:flutter/material.dart';

class LoginModel {
  String email;
  String status;
  bool success;
  String password;
  String last_name;
  String first_name;

  LoginModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    Map<String, dynamic> dataJson =
        json.containsKey("data") ? json["data"] : null;
    if (dataJson == null) {
      return;
    }
    if (dataJson.containsKey("status") && dataJson["status"] == 200) {
      if (dataJson.containsKey("success") && dataJson["success"]) {
        email = dataJson.containsKey("email") ? dataJson["email"] : "";
        last_name =
            dataJson.containsKey("last_name") ? dataJson["last_name"] : "";
        first_name =
            dataJson.containsKey("first_name") ? dataJson["first_name"] : "";
      }
    }
  }
}

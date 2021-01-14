import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'LoginModel.dart';

class SessionManager {
  static const String PREF_KEY_FNAME = 'com.pref.PREF_KEY_FNAME';
  static const String PREF_KEY_LNAME = 'com.pref.PREF_KEY_LANME';
  static const String PREF_KEY_EMAIL = 'com.pref.PREF_KEY_EMAIL';
  static const String PREF_ENABLE_TOUCH_ID = 'com.pref.PREF_KEY_TOUCH_ID';

  static final SessionManager _singleton = new SessionManager._internal();

  Future<SharedPreferences> _mPref;

  factory SessionManager() {
    return _singleton;
  }

  SessionManager._internal() {
    _initPref();
  }

  _initPref() {
    _mPref = SharedPreferences.getInstance();
  }

  Future<bool> saveLoginSession(LoginModel user) async {
    final SharedPreferences _prefs = await _mPref;
    _prefs.setString(PREF_KEY_EMAIL, user.email);
    _prefs.setString(PREF_KEY_FNAME, user.first_name);
    _prefs.setString(PREF_KEY_LNAME, user.last_name);
  }

  Future<bool> logoutUser() async {
    bool touchId = await getTouchIdStatus();
    final SharedPreferences _prefs = await _mPref;
    _prefs.clear();
    enableTouchId(touchId);
  }

  Future<bool> enableTouchId(bool enableTouchId) async {
    final SharedPreferences _prefs = await _mPref;
    _prefs.setBool(PREF_ENABLE_TOUCH_ID, enableTouchId);
  }

  Future<bool> getTouchIdStatus() async {
    final SharedPreferences _prefs = await _mPref;
    return _prefs.getBool(PREF_ENABLE_TOUCH_ID);
  }

  Future<String> getEmail() async {
    final SharedPreferences _prefs = await _mPref;
    return _prefs.getString(PREF_KEY_EMAIL);
  }

  Future<String> getFirstName() async {
    final SharedPreferences _prefs = await _mPref;
    return _prefs.getString(PREF_KEY_FNAME);
  }

  Future<String> getLName() async {
    final SharedPreferences _prefs = await _mPref;
    return _prefs.getString(PREF_KEY_LNAME);
  }
}

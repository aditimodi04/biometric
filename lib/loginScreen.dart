import 'dart:async';
import 'dart:convert';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:task_demo/AccountDetails.dart';
import 'package:task_demo/LoginModel.dart';
import 'package:task_demo/biometricScreen.dart';
import 'package:task_demo/session_manager.dart';
import 'common_util.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _saving = false;
  String _password;
  final LocalAuthentication auth = LocalAuthentication();

  TextEditingController _emailFieldController = TextEditingController();
  TextEditingController _passwordFieldController = TextEditingController();
  FocusNode _phoneFocus;
  FocusNode _passwordFocus;
  String _email = "";

  @override
  void initState() {
    super.initState();
    _passwordFocus = FocusNode();
    SessionManager().getTouchIdStatus().then((value) => {
          if (value != null) {_authenticateToLogin()}
        });
  }

  @override
  void dispose() {
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget email = Padding(
        padding: EdgeInsets.only(left: 8, right: 8, top: 10.0),
        child: Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.black54),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: _emailFieldController,
            validator: (value) {
              if (value.trim().isEmpty) return 'Email cannot be blank';
              if (!CommonUtil.isValidEmail(value.trim()))
                return 'Invalid Email Id';
              return null;
            },
            onSaved: (value) => _email = value.trim(),
            decoration: InputDecoration(
              icon: const Icon(Icons.email),
              labelText: 'Email',
            ),
          ),
        ));

    final password = Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 10.0),
      child: Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.black54),
        child: TextFormField(
          obscureText: true,
          focusNode: _passwordFocus,
          controller: _passwordFieldController,
          validator: (value) {
            if (value.trim().isEmpty) {
              return 'Password cannot be blank';
            }
            if (value.trim().length < 6) {
              return 'Password must be greater than 6 characters.';
            }
            return null;
          },
          onSaved: (value) => _password = value.trim(),
          decoration: InputDecoration(
            icon: const Icon(Icons.lock),
            labelText: 'Password',
          ),
        ),
      ),
    );

    final loginButton = Padding(
        padding: EdgeInsets.only(top: 26.0),
        child: RaisedButton(
            onPressed: _onLoginButtonTap,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: new Text('Login', style: TextStyle(color: Colors.white))));

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                SizedBox(height: 20.0),
                email,
                password,
                loginButton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setFocusOnFields() {
    if (CommonUtil.isStringEmpty(_passwordFieldController.text) &&
        _passwordFieldController.text.length < 6) {
      FocusScope.of(context).requestFocus(_passwordFocus);
    } else {
      _passwordFocus.unfocus();
    }
  }

  Future<LoginModel> doLogin() async {
    String url = 'https://api.mocki.io/v1/b4209c6d';
    final response = await http.get('$url');
    Dialog(
      child: Text("Response is $response"),
    );
    if (response != null) {
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return LoginModel.fromJson(jsonData);
      } else {
        return null;
      }
    }
    return null;
  }

  Future _onLoginButtonTap() async {
    _setFocusOnFields();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      ArsProgressDialog progressDialog = ArsProgressDialog(context,
          blur: 2,
          loadingWidget: Container(
            width: 50,
            height: 50,
            color: Colors.transparent,
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          ),
          backgroundColor: Color(0x33000000),
          animationDuration: Duration(milliseconds: 500));

      progressDialog.show(); // show dialog

      LoginModel loginModel = await doLogin();
      if (loginModel != null) {
        SessionManager().saveLoginSession(loginModel);
        bool bioEnable = await _checkBiometrics();
        progressDialog.dismiss();
        if (bioEnable) {
          biometricModelSheet(context);
        } else {
          redirectToAccountDetails();
        }
      } else {
        showErrorDialog();
      }
    }
  }

  Dialog showErrorDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Column(
        children: [
          Center(child: Icon(Icons.error, color: Colors.red)),
          Center(
              child: Text(
            "Something Went wrong. Please try again",
            style: TextStyle(fontSize: 16, color: Colors.red),
          )),
          Center(
              child: RaisedButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ))
        ],
      ),
    );
  }

  redirectToAccountDetails() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AccountDetails()),
        (Route<dynamic> route) => false);
  }

  void biometricModelSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Enable Touch Id for App",
                    style: TextStyle(fontSize: 20),
                  ),
                )),
                new ListTile(
                    title: new Text(
                      'Enable Touch Id',
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () => {_authenticate()}),
                new ListTile(
                  title: new Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () => {redirectToAccountDetails()},
                ),
              ],
            ),
          );
        });
  }

  Future<bool> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      if (canCheckBiometrics) {
        List<BiometricType> list = await auth.getAvailableBiometrics();
        if (list.length > 0) {
          return true;
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
    return false;
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your touch id to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      if (authenticated) {
        SessionManager().enableTouchId(true);
        redirectToAccountDetails();
      }
    } on PlatformException catch (e) {
      auth.stopAuthentication();
      print(e);
    }
    if (!mounted) return;
  }

  Future<void> _authenticateToLogin() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your touch id to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      if (authenticated) {
        SessionManager().enableTouchId(true);
        ArsProgressDialog progressDialog = ArsProgressDialog(context,
            blur: 2,
            loadingWidget: Container(
              width: 50,
              height: 50,
              color: Colors.transparent,
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            ),
            backgroundColor: Color(0x33000000),
            animationDuration: Duration(milliseconds: 500));

        progressDialog.show();
        LoginModel loginModel = await doLogin();
        if (loginModel != null) {
          SessionManager().saveLoginSession(loginModel);
          progressDialog.dismiss();
          redirectToAccountDetails();
        }
      }
    } on PlatformException catch (e) {
      auth.stopAuthentication();
      print(e);
    }
    if (!mounted) return;
  }
}

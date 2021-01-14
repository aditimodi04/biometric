import 'package:flutter/material.dart';
import 'package:task_demo/loginScreen.dart';
import 'package:task_demo/session_manager.dart';

class AccountDetails extends StatefulWidget {
  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  String fName = "", lName = "", email = "";

  @override
  void initState() {
    SessionManager().getEmail().then((value) {
      setState(() {
        email = value;
      });
    });
    SessionManager().getFirstName().then((value) {
      setState(() {
        fName = value;
      });
    });
    SessionManager().getLName().then((value) {
      setState(() {
        lName = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title: Text("Manager Account"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              SessionManager().logoutUser();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      body: Card(
        margin: EdgeInsets.all(10),
        elevation: 5,
        child: Wrap(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "$fName $lName",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
              child: Text(
                "$email",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:zagel/eventScreen.dart';
import 'package:zagel/options.dart';

class WatchRaceLoginScreen extends StatefulWidget {
  @override
  _WatchRaceLoginScreenState createState() => _WatchRaceLoginScreenState();
}

class _WatchRaceLoginScreenState extends State<WatchRaceLoginScreen> {
  late DatabaseReference ref;
  late FocusNode idFocusNode;
  late FocusNode passwordFocusNode;

  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;

  String enteredId = '';
  Color idBorderColor = Colors.blueGrey;
  double idBorderWidth = 1.0;
  Color passwordBorderColor = Colors.blueGrey;
  double passwordBorderWidth = 1.0;

  void togglePasswordVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  void initState() {
    super.initState();

    ref = FirebaseDatabase.instance.ref();
    idFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    idFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OptionsScreen()));
          },
        ),
        title: Text(
          'Experience an event',
          style: GoogleFonts.quicksand(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your event ID',
                  style: GoogleFonts.quicksand(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: idBorderColor,
                      width: idBorderWidth,
                    ),
                  ),
                  child: TextFormField(
                    controller: idController,
                    focusNode: idFocusNode,
                    style: GoogleFonts.quicksand(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Please enter the event ID',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: InputBorder.none,
                    ),
                    onTap: () {
                      setState(() {
                        idBorderColor = Colors.blue;
                        idBorderWidth = 3.0;
                        passwordBorderColor = Colors.blueGrey;
                        passwordBorderWidth = 1.0;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password',
                  style: GoogleFonts.quicksand(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: passwordBorderColor,
                      width: passwordBorderWidth,
                    ),
                  ),
                  child: TextFormField(
                    obscureText: !showPassword,
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    style: GoogleFonts.quicksand(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Please enter a password',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: togglePasswordVisibility,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        passwordBorderColor = Colors.blue;
                        passwordBorderWidth = 3.0;
                        idBorderColor = Colors.blueGrey;
                        idBorderWidth = 1.0;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.plus,
                  size: 30.0,
                  color: Colors.white,
                ),
                onPressed: () {
                  _openEvent();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openEvent() async {
    enteredId = idController.text;
    String password = passwordController.text;
    DataSnapshot idSnapshot = await ref.child('events/$enteredId/id').get();
    DataSnapshot passwordSnapshot = await ref.child('events/$enteredId/password').get();
    if (enteredId == idSnapshot.value.toString()) {
      if (password == passwordSnapshot.value.toString()) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => EventScreen(enteredId: enteredId)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Password is not correct',
              textAlign: TextAlign.center,
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            width: MediaQuery.of(context).size.width * 0.5,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'The ID you entered doesn\'t exist',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          width: MediaQuery.of(context).size.width * 0.5,
        ),
      );
    }
  }
}

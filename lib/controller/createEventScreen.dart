import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:zagel/options.dart';
import 'package:zagel/pigeons.dart';
import 'firebase_options.dart';
import 'package:zagel/eventScreen.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  late DatabaseReference ref;
  late DataSnapshot snapshot;
  late FocusNode passwordFocusNode;

  String randomId = generateRandomId();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;

  static String generateRandomId() {
    Random random = Random();
    int id = random.nextInt(90000) + 10000; // Generate a 5-digit random number
    return id.toString();
  }

  void togglePasswordVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  void initState() {
    super.initState();

    ref = FirebaseDatabase.instance
        .reference()
        .child('events/${randomId}');
    passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Removes the shadow
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Add back button icon
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OptionsScreen()));
          },
        ),
        title: Text(
          'Creating an event',
          style: GoogleFonts.quicksand(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true, // Center-align the title
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
                    border: Border.all(color: Colors.blueGrey),
                  ),
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: randomId),
                    style: GoogleFonts.quicksand(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: '',
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: InputBorder.none,
                    ),
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
                      color: passwordFocusNode.hasFocus ? Colors.blue : Colors.blueGrey,
                      width: passwordFocusNode.hasFocus ? 3.0 : 1.0, // Set the border width to 3 pixels
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
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: togglePasswordVisibility,
                      ),
                    ),
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
                  createEvent();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createEvent() {
    String password = passwordController.text.trim();

    if (password.isNotEmpty && password.length >= 8) {
      setState(() {
        ref.child('id').set(randomId);
        ref.child('password').set(password);
        passwordController.clear();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PigeonFeatures(enteredId: randomId)));
      });
    } else {
      // Show a snackbar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password should be at least 8 characters long.',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0), // Adjust the border radius as needed
          ),
          width: MediaQuery.of(context).size.width * 0.6, // Adjust the width as needed
        ),
      );
    }
  }
}
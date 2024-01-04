import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zagel/controller/createEventScreen.dart';
import 'package:zagel/screens/login_screen/watchLogin.dart';

class OptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding:
              EdgeInsets.only(top: 100), // Top padding for the entire column
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 40), // Left padding for the button
                  child: Text(
                    'What do you want to do?',
                    style: GoogleFonts.quicksand(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth *
                                  0.02), // Left padding for the first button
                          child: Container(
                            width: screenWidth *
                                0.4, // Responsive width as a fraction of the screen width
                            height: 300,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => CreateScreen()));
                              },
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                side: BorderSide(
                                  color: Colors.blue, // Gray border color
                                  width: 3.0, // Set the outline width to 3px
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Adjust the border radius as needed
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                child: Text(
                                  'Create an event',
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth *
                                  0.02), // Left padding for the second button
                          child: Container(
                            width: screenWidth *
                                0.4, // Responsive width as a fraction of the screen width
                            height: 300,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            WatchRaceLoginScreen()));
                              },
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                side: BorderSide(
                                  color: Colors.blue, // Gray border color
                                  width: 3.0, // Set the outline width to 3px
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Adjust the border radius as needed
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                child: Text(
                                  'Experience an event',
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

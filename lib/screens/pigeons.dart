import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zagel/screens/blue_devices/bleDevices.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zagel/screens/eventScreen.dart';
import 'package:zagel/screens/options.dart';
import '../controller/firebase_options.dart';

class PigeonFeatures extends StatefulWidget {
  const PigeonFeatures({Key? key, required this.enteredId}) : super(key: key);

  final String enteredId;
  @override
  _PigeonFeaturesState createState() => _PigeonFeaturesState();
}

class _PigeonFeaturesState extends State<PigeonFeatures> {
  late DatabaseReference ref;
  late DataSnapshot snapshot;

  TextEditingController colorController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController clubController = TextEditingController();
  TextEditingController ringNumberController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  String color = '';
  String country = '';
  String club = '';
  String ringNumber = '';
  String gender = '';
  String genderIcon = '';
  int selectedValue = DateTime.now().year;
  String year = '';

  bool showLifeBandContent = true;

  bool countryError = false;
  bool clubError = false;
  bool ringNumberError = false;
  bool genderError = false;
  bool colorError = false;

  int pigeonsNumber = 0;

  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();

    ref = FirebaseDatabase.instance
        .reference()
        .child('events/${widget.enteredId}/pigeons');

    // Attach a listener to the database reference
    ref.onValue.listen((event) {
      // Check if the snapshot has data
      if (event.snapshot.value != null) {
        String pigeonsData = event.snapshot.value.toString();
        List<String> pigeonsList = pigeonsData.split(', ');
        setState(() {
          pigeonsNumber = pigeonsList.length;
        });
      } else {
        setState(() {
          pigeonsNumber = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: [
            Text(
              'Adding a Pigeon',
              style: GoogleFonts.quicksand(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'Event ID: ${widget.enteredId}',
              style: GoogleFonts.quicksand(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'Pigeons: ${pigeonsNumber}',
              style: GoogleFonts.quicksand(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bluetooth, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      BleDevicesScreen(enteredId: widget.enteredId),
                ),
              );
            },
          ),
          pigeonsNumber == 0
              ? IconButton(
                  icon: Icon(Icons.close, color: Colors.black), // X mark icon
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => OptionsScreen(),
                      ),
                    );
                  },
                )
              : IconButton(
                  icon: Icon(Icons.done, color: Colors.black), // Done icon
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Done',
                          textAlign: TextAlign.center, // Center-align the text
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              50.0), // Adjust the border radius as needed
                        ),
                        width: MediaQuery.of(context).size.width *
                            0.3, // Adjust the width as needed
                      ),
                    );

                    // Wait for 1 second before navigating
                    Future.delayed(Duration(milliseconds: 100), () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) =>
                                EventScreen(enteredId: widget.enteredId)),
                      );
                    });
                  },
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  SizedBox(height: 40),
                  Text(
                    'Life Band',
                    style: GoogleFonts.quicksand(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: _buildLifeBandContent(),
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildInputField('Country', countryController, (value) {
                    setState(() {
                      country = value;
                    });
                  }),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Year',
                        style: GoogleFonts.quicksand(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                      CupertinoButton.filled(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            selectedValue.toString(),
                            style: GoogleFonts.quicksand(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () => showCupertinoModalPopup(
                          context: context,
                          builder: (_) => SizedBox(
                            width: double.infinity,
                            height: 300,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors
                                    .white, // Set the background color to white
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                      20.0), // Adjust the radius as needed
                                  topRight: Radius.circular(
                                      20.0), // Adjust the radius as needed
                                ),
                              ),
                              padding: EdgeInsets.only(
                                  top:
                                      16.0), // Adjust the top padding as needed
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Select Year',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      decorationColor: Colors.blue,
                                      decorationThickness:
                                          3, // Set the thickness to 2 pixels
                                    ),
                                  ),
                                  Expanded(
                                    child: CupertinoPicker(
                                      backgroundColor: Colors.white,
                                      itemExtent: 30,
                                      scrollController:
                                          FixedExtentScrollController(
                                        initialItem: selectedValue,
                                      ),
                                      children: List.generate(
                                        20, // Adjust the number of years as needed
                                        (index) => Text(
                                          '${DateTime.now().year - index}',
                                        ),
                                      ),
                                      onSelectedItemChanged: (int value) {
                                        setState(() {
                                          selectedValue =
                                              DateTime.now().year - value;
                                          year =
                                              (selectedValue % 100).toString();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _buildInputField('Club', clubController, (value) {
                    setState(() {
                      club = value;
                    });
                  }),
                  SizedBox(height: 10),
                  _buildNumericInputField('Ring Number', ringNumberController,
                      (value) {
                    setState(() {
                      ringNumber = value;
                    });
                  }),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gender',
                        style: GoogleFonts.quicksand(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: gender == 'Male'
                                  ? Colors.blue
                                  : Colors
                                      .grey, // Set color based on selected gender
                            ),
                            child: IconButton(
                              icon: FaIcon(
                                FontAwesomeIcons.mars,
                                size: 30.0,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  gender = 'Male';
                                  genderIcon = '♂'; // Set gender icon for male
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: gender == 'Female'
                                  ? Colors.pink
                                  : Colors
                                      .grey, // Set color based on selected gender
                            ),
                            child: IconButton(
                              icon: FaIcon(
                                FontAwesomeIcons.venus,
                                size: 30.0,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  gender = 'Female';
                                  genderIcon =
                                      '♀'; // Set gender icon for female
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _buildInputField('Color', colorController, (value) {
                    setState(() {
                      color = value;
                    });
                  }),
                  SizedBox(height: 10),
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
                        _updateLifeBandContent();
                        _uploadLifeBandContent();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLifeBandContent() {
    Color genderIconColor = Colors.black; // Default color

    if (gender == 'Male') {
      genderIconColor = Colors.blue;
    } else if (gender == 'Female') {
      genderIconColor = Colors.pink;
    }

    return showLifeBandContent
        ? RichText(
            text: TextSpan(
              style: GoogleFonts.quicksand(
                fontSize: MediaQuery.of(context).size.width * 0.045,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
              children: [
                TextSpan(text: '$country  ${year}  $club  $ringNumber  '),
                TextSpan(
                  text: genderIcon,
                  style: TextStyle(
                    color: genderIconColor,
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                TextSpan(text: '  $color'),
              ],
            ),
          )
        : Container();
  }

  void _updateLifeBandContent() {
    if (country.isNotEmpty &&
        club.isNotEmpty &&
        ringNumber.isNotEmpty &&
        gender.isNotEmpty &&
        color.isNotEmpty) {
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all the required fields',
            textAlign: TextAlign.center, // Center-align the text
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                50.0), // Adjust the border radius as needed
          ),
          width: MediaQuery.of(context).size.width *
              0.6, // Adjust the width as needed
        ),
      );
    }
  }

  void _uploadLifeBandContent() {
    if (country.isNotEmpty &&
        club.isNotEmpty &&
        ringNumber.isNotEmpty &&
        gender.isNotEmpty &&
        color.isNotEmpty) {
      setState(() {
        ref.child(ringNumber).set(
            '$country  ${selectedValue % 100}  $club  $ringNumber  $genderIcon  $color');

        // Clear input fields
        countryController.clear();
        clubController.clear();
        ringNumberController.clear();
        colorController.clear();

        // Reset gender selection and hide life band content
        country = '';
        club = '';
        ringNumber = '';
        color = '';
        year = '';
        gender = '';
        genderIcon = '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all the required fields',
            textAlign: TextAlign.center, // Center-align the text
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                50.0), // Adjust the border radius as needed
          ),
          width: MediaQuery.of(context).size.width *
              0.6, // Adjust the width as needed
        ),
      );
    }
  }

  Widget _buildInputField(String title, TextEditingController controller,
      Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
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
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Enter $title',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumericInputField(String title, TextEditingController controller,
      Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
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
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: 'Enter $title',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

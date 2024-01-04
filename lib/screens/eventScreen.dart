import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zagel/options.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key, required this.enteredId}) : super(key: key);

  final String enteredId;

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late DatabaseReference ref;
  late int pigeonsNumber;

  @override
  void initState() {
    super.initState();

    ref = FirebaseDatabase.instance.reference().child('events/${widget.enteredId}/pigeons');

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
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Add back button icon
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OptionsScreen()));
          },
        ),
        title: Column(
          children: [
            Text(
              'Pigeons in the event',
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
              'Pigeons: $pigeonsNumber',
              style: GoogleFonts.quicksand(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: FirebaseAnimatedList(
        query: ref,
        defaultChild: Center(
          child: CircularProgressIndicator(),
        ),
        itemBuilder: (context, snapshot, animation, index) {
          // setState(() {
          //   pigeonsNumber = index;
          // });
          return Card(
            elevation: 0.0,
            margin: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          snapshot.child('pigeons').value.toString(),
                          style: GoogleFonts.rubik(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

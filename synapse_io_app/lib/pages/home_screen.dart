import 'package:animate_do/animate_do.dart';
import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chatscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Color> primaryColors = const [
    Colors.white,
    Color.fromARGB(255, 236, 207, 217),
    Color.fromARGB(255, 192, 198, 255),
  ];
  List<Color> secondaryColors = const [
    Color.fromARGB(255, 231, 187, 255),
    Color.fromARGB(255, 209, 226, 255),
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimateGradient(
        primaryBeginGeometry: const AlignmentDirectional(0, 1),
        primaryEndGeometry: const AlignmentDirectional(0, 2),
        secondaryBeginGeometry: const AlignmentDirectional(2, 0),
        secondaryEndGeometry: const AlignmentDirectional(0, -0.8),
        textDirectionForGeometry: TextDirection.rtl,
        primaryColors: primaryColors,
        secondaryColors: secondaryColors,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeInUp(
                    child: Text(
                      "Synapse.io",
                      style: GoogleFonts.poppins(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  FadeInUp(
                    delay: Duration(milliseconds: 10),
                    child: Text(
                      "from TEXT to SQL QUERY",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w300),
                    ),
                  ),
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chatscreen(),
                        ),
                      );
                    },
                    child: FadeIn(
                      delay: Duration(seconds: 1),
                      child: Container(
                        padding:
                            EdgeInsets.all(15).copyWith(left: 50, right: 50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.blueAccent,
                        ),
                        child: Text(
                          'Start Chatbot',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Wood Pecker 2024'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

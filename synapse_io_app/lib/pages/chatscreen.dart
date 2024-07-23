import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../database/database_handler.dart';
import '../models/messages_model.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
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

  final scrollController = ScrollController();
  final TextEditingController _nlQueryController = TextEditingController();
  final List<ChatMessages> _messages = [];

  void _sendMessages() async {
    final nlQuery = _nlQueryController.text;
    if (nlQuery.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessages(sender: 'user', text: nlQuery));
    });
    _nlQueryController.clear();
    FocusScope.of(context).unfocus();

    try {
      final result = await DatabaseHelper().executeQuery(nlQuery);
      if (result.isEmpty) {
        setState(() {
          _messages.add(
              ChatMessages(sender: 'bot', text: 'Executed, but no results'));
        });
      } else {
        setState(() {
          _messages.add(
              ChatMessages(sender: 'bot', text: 'Query executed successfully'));
          _messages.add(ChatMessages(sender: 'bot', table: result));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(
            ChatMessages(sender: 'bot', text: 'Wrong query: ${e.toString()}'));
      });
    }
  }

  Widget _buildResultTable(List<Map<String, dynamic>> result) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: result.first.keys
            .map((key) => DataColumn(
                    label: Text(
                  key,
                  style: TextStyle(color: Colors.white),
                )))
            .toList(),
        rows: result
            .map(
              (row) => DataRow(
                cells: row.values
                    .map(
                      (value) => DataCell(
                        Text(
                          value.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // appBar: AppBar(
      //   title: Text(
      //     'Synapse.io',
      //     style: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: 30),
      //   ),
      // ),
      body: AnimateGradient(
        primaryBeginGeometry: const AlignmentDirectional(0, 1),
        primaryEndGeometry: const AlignmentDirectional(0, 2),
        secondaryBeginGeometry: const AlignmentDirectional(2, 0),
        secondaryEndGeometry: const AlignmentDirectional(0, -0.8),
        textDirectionForGeometry: TextDirection.rtl,
        primaryColors: primaryColors,
        secondaryColors: secondaryColors,
        child: Column(
          children: [
            SafeArea(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Synapse.io',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300, fontSize: 30),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _messages.length,
                controller: scrollController,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message.sender == 'user';
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.blueAccent
                            : const Color.fromARGB(255, 80, 79, 79),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: message.text != null
                          ? Text(
                              message.text!,
                              style: TextStyle(color: Colors.white),
                            )
                          : _buildResultTable(message.table!),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nlQueryController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35)),
                        labelText: 'Enter SQL Query',
                      ),
                    ),
                  ),
                  IconButton(onPressed: _sendMessages, icon: Icon(Icons.send))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

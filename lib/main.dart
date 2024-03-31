import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'components/rss_feed.dart';
import 'services/communication_service.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RSS Feed App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPageWidget(),
    );
  }
}

class MainPageWidget extends StatefulWidget {
  @override
  _MainPageWidgetState createState() => _MainPageWidgetState();
}

class _MainPageWidgetState extends State<MainPageWidget> {
  final TextEditingController _inputController = TextEditingController();
  List<String> _suggestions = [];
  String rssFeedValue = '';
  final CommunicationService _communicationService = CommunicationService();

  // Callback function to update value in child widget
  void updateRssFeedValue(String newValue) {
    setState(() {
      rssFeedValue = newValue;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchSuggestions();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _selectSuggestion(String suggestion) {
    print('Selected suggestion: $suggestion');
    _inputController.text = suggestion;
  }

  Future<void> _fetchRssFeed() async {
    updateRssFeedValue(_inputController.text);
  }

  Future<void> _fetchSuggestions() async {
    final String response = await _communicationService.fetchSuggestions();
    if (response.isNotEmpty) {
      List<String> stringList = (jsonDecode(response) as List<dynamic>).cast<String>();
      setState(() {
        _suggestions = stringList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RSS Feed App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      labelText: 'Input',
                      hintText: 'Enter account or channel...',
                    ),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    _fetchRssFeed();
                    Timer(Duration(seconds: 2), () {
                      _fetchSuggestions();
                    });
                  },
                  tooltip: 'Fetch RSS Feed',
                  child: Icon(Icons.rss_feed),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    title: Text(suggestion),
                    onTap: () {
                      _selectSuggestion(suggestion);
                    },
                  );
                },
              ),
            ),
            Expanded( child: RssFeedWidget(value: rssFeedValue)),
          ],
        ),
      ),
    );
  }
}

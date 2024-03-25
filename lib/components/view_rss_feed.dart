import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewRssFeedWidget extends StatefulWidget {
  final _rssFeed;
  ViewRssFeedWidget({Key? key, required dynamic RssFeed}) : _rssFeed = RssFeed, super(key: key);


  @override
  State<ViewRssFeedWidget> createState() => _ViewRssFeedWidgetState(_rssFeed);
}

class _ViewRssFeedWidgetState extends State<ViewRssFeedWidget> {
  final _rssFeed;
  _ViewRssFeedWidgetState(this._rssFeed);


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(_rssFeed['title']),
        centerTitle: true,
      ),
      body:Stack(
        children: [
          ListView(
                children: [
                  SizedBox(height: 10,),
                  Text(_rssFeed['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Ionicons.time_outline),
                      Text(DateFormat('MMM dd yyyy hh:mm').format(
                          DateTime.parse(
                              _rssFeed['pubDate']!.toString()))),
                      Spacer(),
                      Icon(Ionicons.person_outline),
                      Text(_rssFeed['author'])
                    ],
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton.icon(onPressed:() => launchUrl(_rssFeed['link']), icon: Icon(Ionicons.link), label: Text('Visit link')),
                  SizedBox(height: 15,),
                  Html(
                    data: _rssFeed['content'],
                  )
                ],
              )

        ],
      ) ,

    );
  }
}

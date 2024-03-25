import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:app/components/view_rss_feed.dart';


class RssFeedWidget extends StatefulWidget {

  final String value;

  const RssFeedWidget({super.key, required this.value});

  @override
  State<RssFeedWidget> createState() => _RssFeedWidgetState();
}

class _RssFeedWidgetState extends State<RssFeedWidget> {
  bool isAdVisible=false;
  bool isLoading=false;
  late RssFeed rss=RssFeed();
  late String value;
  final String NO_IMAGE = '/icons/no_image.png';

  // Method to refresh the feed based on the new query
  void refreshState(String val) {
    setState(() {
      value = val;
      showData();
    });
  }

  void showData() {
    if (value.isNotEmpty) {
      isAdVisible = true;
      loadData();
    }
  }

  @override
  void didUpdateWidget(covariant RssFeedWidget oldWidget) {

    // Fetch data again whenever the parameter value changes
    if (widget.value != oldWidget.value) {
      refreshState(widget.value);
    }
    super.didUpdateWidget(oldWidget);
  }

 @override
  void initState() {
    super.initState();
    value = widget.value.toString();
    showData();
  }

   loadData() async {

     try {
       setState(() {
         isLoading = true;
       });

       // For debugging
       // print(this.value);

       // This is an open REST API endpoint for testing purposes
       String url = "http://localhost:8080/feed/$value";
       final response = await get(Uri.parse(url));
       if (response.statusCode == 200 && response.body.isNotEmpty) {
         var channel = RssFeed.parse(response.body);
         setState(() {
           rss = channel;
           isLoading = false;
         });
       } else {
         setState(() {
           isAdVisible = false;
           isLoading = false;
         });
       }
     } catch (err) {
       throw err;
     }
  }

  String handleImage(RssItem item) {
    String image = NO_IMAGE;
    if (item.content != null) {
      image = item.content!.images.elementAt(0).toString();
    } else if (item.description!.isNotEmpty) {
      String description = item.description!.toString();
      int startIndex = description.indexOf('<img src="');
      if (startIndex > -1) {
        int endIndex = description.indexOf('"', startIndex + 1);
        int finalIndex = description.indexOf('"', endIndex + 1);
        image = description.substring(endIndex + 1, finalIndex);
      }
    }

    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Stack(
          children: [
            isLoading==true ? Center(child: CircularProgressIndicator()) :
            isAdVisible==true ?
              ListView.builder(
                 itemCount: rss.items!.isNotEmpty ? rss.items!.length : 1,
                 itemBuilder: (BuildContext context, index) {
                   var item;
                   var feedItems;
                   String image;
                   if (rss.items!.isNotEmpty) {
                     item = rss.items![index];
                     feedItems = {
                       'title': item.title,
                       'content': item.content != null ? item.content!.value : item.description,
                       'creator': item.dc!.creator,
                       'link': item.link,
                       'pubDate': item.pubDate,
                       'author': item.dc!.creator
                     };
                     image = handleImage(item);
                   } else {
                     item = rss;
                     image = item.image != null ? item.image.url : '/icons/no_image.png';

                     // Parse the string date to a DateTime object
                     DateTime dateTime = DateFormat('E, d MMM yyyy HH:mm:ss').parse(item.lastBuildDate);

                     // Format the DateTime object to a full date format
                     String imageUrl = rss.image!.url!.toString();
                     String imageTitle = rss.image!.title!.toString();

                     // HTML content with an <img> tag
                     String htmlContent = '<img src="$imageUrl" alt="$imageTitle">';
                     feedItems = {
                      'title': rss.title,
                      'content': htmlContent,
                      'creator': rss.dc!.creator,
                      'link': rss.link,
                      'pubDate': dateTime.toString(),
                      'author': rss.author?? rss.generator,
                      };
                   }

                   // For debugging
                   // print(feedItems);
                   return InkWell(
                       onTap: () =>
                           Navigator.push(context,
                               MaterialPageRoute(builder:
                                   (context) =>
                                   ViewRssFeedWidget(RssFeed: feedItems)
                               )
                           ),
                       child: ListTile(

                         leading: Image(
                             image: CachedNetworkImageProvider(
                                 image
                             )),
                         title: Text(item.title.toString()),
                         subtitle: Row(
                           children: [
                             Icon(Ionicons.time_outline),

                             Text(DateFormat('MMM dd yyyy hh:mm').format(
                                 DateTime.parse(feedItems['pubDate']!.toString()))),
                             Spacer(),
                             Icon(Ionicons.person_outline),
                             Text(feedItems['author']!.toString())
                           ],
                         ),
                       )
                   );
                 }
             )
          : Center(child: Text('No data to display')),
          ],
        ) ,

    );
  }
}

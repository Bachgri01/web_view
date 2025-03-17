// import 'package:demo/webView.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import if using platform views
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:new_web_view/webView.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (WebView.platform == null) {
    WebView.platform = SurfaceAndroidWebView();
  }
  // Workmanager().registerPeriodicTask(
  //   "periodicTaskKey",
  //   "simplePeriodicTask",
  //   frequency: Duration(seconds: 5), // Minimum interval is 15 minutes
  //   inputData: <String, dynamic>{
  //     'message': 'Hello from the periodic task!',
  //   },
  // );
  // Workmanager()
  //     .initialize(callbackDispatcher); // Add this line for initialization
  // Workmanager().registerOneOffTask(
  //                     "simpleTaskKey",
  //                     "simpleTaskKey",
  //                     inputData: <String, dynamic>{
  //                       'int': 1,
  //                       'bool': true,
  //                       'double': 1.0,
  //                       'string': 'string',
  //                       'array': [1, 2, 3],
  //                     },
  //                   );
  runApp(MyApp());
}

Future<void> showNotification(dynamic id) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await Permission.notification.request();
  print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
   const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    print('Failed to load data from API');
    await flutterLocalNotificationsPlugin.show(
        0,
        'IS Message',
        'hh iwa ch adir',
        platformChannelSpecifics,
        payload: id);
  // final response =
  //     await http.get(Uri.parse('http://unionlabo.ma:3060/api/notif/$id'));
  // if (response.statusCode == 200) {
  //   var data = json.decode(response.body);
  //   // You can extract specific data you want to use from the response
  //   if (data.length < 1) return;
  //   String sender = data.length > 0
  //       ? data[0]['author_name']
  //       : ""; // Adjust based on the API response
  //   String me = data[0]['recipient_name']; // Adjust based on the API response
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails('your_channel_id', 'your_channel_name',
  //           channelDescription: 'your_channel_description',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //           ticker: 'ticker');

  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //   String r = data.length < 2 ? '$sender' : '';
  //   await flutterLocalNotificationsPlugin.show(
  //       0,
  //       'IS Message',
  //       'Vous avez ${data.length} nouveaux messages ${r}',
  //       platformChannelSpecifics,
  //       payload: id);
  // } else {
   
  // }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // This function runs in the background every 15 minutes
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? storedUserId = prefs.getString('userid');

    debugPrint('Stored User ID ===================:> $task');
    debugPrint("Periodic task is running!");
    showNotification(task);
    return Future.value(
        true); // Always return true when the task completes successfully
  });
  // Workmanager().executeTask((task, inputData) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? storedUserId = prefs.getString('userid');
  //   print('Stored User ID ===================:> $storedUserId');
  //   print("Background task executed");
  //   return Future.value(true);
  // });
}

class MyApp extends StatelessWidget {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 113, 99, 158),
          toolbarHeight: 0,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [

              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 113, 99, 158),
                ),

                child: Text(
                  'My App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
              ListTile(
                leading:const Icon(Icons.home),
                title:const Text('Home'),
                onTap: () {
                  // Handle Home click
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile( 
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Handle Settings click
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
                onTap: () {
                  // Handle About click
                  Navigator.pop(context); // Close the drawer
                },
              ),
              // Add more items as needed
            ],
          ),
        ),
        body: WebViewDemo(),
        // floatingActionButton: 
        // Stack(
        // children: [
        //   // First FAB: Positioned at the top left
        //   Positioned(
        //     left: 80,
        //     top: 40,
        //     child: Container(
        //       height: 53, // Custom height
        //       width: 60,  // Custom width
        //       color: Color.fromARGB(255, 113, 99, 158), 
        //       child: TextButton(
        //         onPressed: () {
        //           // Check if the drawer is open or closed, and toggle it
        //           if (_scaffoldKey.currentState!.isDrawerOpen) {
        //             _scaffoldKey.currentState!.closeDrawer();
        //           } else {
        //             _scaffoldKey.currentState!.openDrawer();
        //           }
        //         },
        //         child: Icon(Icons.menu), // Icon for the FAB
                
        //         //backgroundColor: Color.fromARGB(255, 113, 99, 158)
        //       ),
        //     ),
        //   ),
        // ],
      // ),
        
      ),
    );
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

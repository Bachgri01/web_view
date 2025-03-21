// import 'package:demo/webView.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import if using platform views
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:new_web_view/webView.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:workmanager/workmanager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WebView.platform;
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
  

class MyApp extends StatelessWidget {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 30, 100, 230),
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

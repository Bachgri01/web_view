// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';

// class WebViewDemo extends StatefulWidget {
//   @override
//   _WebViewDemoState createState() => _WebViewDemoState();
// }

// class _WebViewDemoState extends State<WebViewDemo> {
//   bool _hasPermission = false;

//   @override
//   void initState() {
//     super.initState();
//     _checkPermissions();
//   }

//   // Check and request necessary permissions
//   void _checkPermissions() async {
//     // Request permissions for camera, microphone, and location
//     PermissionStatus cameraStatus = await Permission.camera.request();
//     PermissionStatus microphoneStatus = await Permission.microphone.request();
//     PermissionStatus locationStatus = await Permission.location.request();

//     if (cameraStatus.isGranted && microphoneStatus.isGranted && locationStatus.isGranted) {
//       setState(() {
//         _hasPermission = true;
//       });
//     } else {
//       // If any permission is denied, show a message or handle accordingly
//       setState(() {
//         _hasPermission = false;
//       });
//       // You can also show a dialog or alert here to inform the user.
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('insight'),
//       // ),
//       body: _hasPermission
//           ? WebView(
//               initialUrl: 'https://uniolabo.ma',
//               javascriptMode: JavascriptMode.unrestricted,
//               debuggingEnabled: true,
//               onWebViewCreated: (WebViewController webViewController) {

//               },
//             )
//           : Center(
//               child: Text('Permissions are required to display the WebView.'),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class WebViewDemo extends StatefulWidget {
  @override
  _WebViewDemoState createState() => _WebViewDemoState();
}

class _WebViewDemoState extends State<WebViewDemo> {
  late InAppWebViewController _webViewController;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initialiseNotif();
    print("register task");
    Workmanager().registerOneOffTask("uniqueName_____", "taskNa___me", initialDelay: const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text("WebView Demo")),
        body: InAppWebView(
      initialUrlRequest:
          URLRequest(url: WebUri.uri(Uri.parse('https://unionlabo.ma'))),

      androidOnGeolocationPermissionsShowPrompt:
          (InAppWebViewController controller, String origin) async {
        return GeolocationPermissionShowPromptResponse(
            origin: origin, allow: true, retain: true);
      },
      androidOnPermissionRequest: (controller, origin, resources) async {
        print("###################");
        print(
            "$origin ${resources.contains('android.webkit.resource.AUDIO_CAPTURE')}");
        print(resources);

        if (resources.contains('android.webkit.resource.AUDIO_CAPTURE')) {
          return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT,
          );
        }
        return PermissionRequestResponse(
          resources: resources,
          action: PermissionRequestResponseAction.GRANT,
        );
      },
      onLoadStop: (controller, url) async {
       
        await controller.evaluateJavascript(source: """
  navigator.permissions.query({name: 'microphone'}).then(function(permissionStatus) {
    if (permissionStatus.state === 'denied') {
      console.log('Microphone permission denied.');
    } else if (permissionStatus.state === 'granted') {
      console.log('Microphone permission granted.');
    } else if (permissionStatus.state === 'prompt') {
      navigator.mediaDevices.getUserMedia({ audio: true }).then(function(stream) {
        console.log('Microphone access granted via prompt.');
        stream.getTracks().forEach(track => track.stop());  // Stop the media stream after acquiring permission
      }).catch(function(error) {
        console.log('Microphone access denied by user.');
      });
    }
  }).catch(function(error) {
    console.log('Permission API or microphone access not supported: ' + error);
  });
""");
      },
      initialOptions: InAppWebViewGroupOptions(
        android: AndroidInAppWebViewOptions(
          useWideViewPort: true,
          geolocationEnabled: true,
          allowContentAccess: true,
          allowFileAccess: true,
          safeBrowsingEnabled: true,

          // mediaPlaybackRequiresUserGesture: false,
        ),
        ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true, sharedCookiesEnabled: true),
      ),
      // androidOnPermissionRequest: (InAppWebViewController controller,
      //     String origin, List<String> resources) async {
      //     return PermissionRequestResponse(
      //         resources: resources,
      //         action: PermissionRequestResponseAction.GRANT);
      // },

      onWebViewCreated: (controller) async {
        // await Permission.microphone.request();
        await requestMicrophonePermission();
        await Future.delayed(Duration(seconds: 5));
        _webViewController = controller;
        startLoopingNotifs();

        // _webViewController.setGeolocationEnabled(true); // Enable geolocation
      },
    )
        // InAppWebView(
        //   initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse('https://uniolabo.ma'))),
        //   onWebViewCreated: (controller) {
        //     _webViewController = controller;
        //     // _webViewController.setGeolocationEnabled(true); // Enable geolocation
        //   },
        //   initialOptions: InAppWebViewGroupOptions(
        //     crossPlatform: InAppWebViewOptions(
        //       javaScriptEnabled: true,

        //       geolocationEnabled: true,  // Ensure this is enabled too
        //     ),
        //   ),
        // ),

        );
  }

  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    print("status is ===============> $status");
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  Future<void> startLoopingNotifs() async {
    
      Timer.periodic(Duration(seconds: 5), (Timer timer) async {
        print("**************************************************");
        print("**************************************************");
        dynamic result = await _webViewController.evaluateJavascript(
          source: 'window.localStorage.getItem("userid");',
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userid', result);
        print(result);
        showNotification(result);
        print("**************************************************");
        print("**************************************************");
      });

    // Timer.periodic(Duration(seconds: 30), (Timer timer) async {
    //   print("**************************************************");
    //   print("**************************************************");
    //   dynamic result = await _webViewController.evaluateJavascript(
    //     source: 'window.localStorage.getItem("userid");',
    //   );

    //   print(result);

    //   print("**************************************************");
    //   print("**************************************************");
    // });
  }

  Future<void> showNotification(dynamic id) async {

    await Permission.notification.request();
    // print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    // final response = await http.get(Uri.parse('http://unionlabo.ma:3060/api/notif/$id'));
    // if (response.statusCode == 200) {
    //   var data = json.decode(response.body);
    //   // You can extract specific data you want to use from the response
    //   if(data.length<1) return;
    //   String sender = data.length>0? data[0]['author_name']: ""; // Adjust based on the API response
    //   String me = data[0]['recipient_name']; // Adjust based on the API response
    //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
    //       AndroidNotificationDetails('your_channel_id', 'your_channel_name',
    //           channelDescription: 'your_channel_description',
    //           importance: Importance.max,
    //           priority: Priority.high,
    //           ticker: 'ticker');

    //   const NotificationDetails platformChannelSpecifics =
    //       NotificationDetails(android: androidPlatformChannelSpecifics);
    //   String r = data.length<2 ? '$sender': '';
    //   await flutterLocalNotificationsPlugin.show(
    //       0, 'IS Message', 'Vous avez ${data.length} nouveaux messages ${r}', platformChannelSpecifics,
    //       payload: id);

    // } else {
    //   print('Failed to load data from API');
    // }
  }

  Future<void> initialiseNotif() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}

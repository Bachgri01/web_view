import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';  
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:permission_handler/permission_handler.dart'; 
// import 'package:workmanager/workmanager.dart';

class WebViewDemo extends StatefulWidget {
  @override
  _WebViewDemoState createState() => _WebViewDemoState();
}

class _WebViewDemoState extends State<WebViewDemo> {
 
   bool isConnected = true; // Track internet connectivity
  @override
  void initState() {
    super.initState(); 
     checkConnectivity();
  }
  void checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });
//lib\webView.dartC:\Users\Dell\Documents\flutter\SDS\unionlabo\new_web_view\lib\webView.dart
    // Listen for changes in network state
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        isConnected = result != ConnectivityResult.none;
      });
    });
  }
  // if there is no connection to internet add special page instead of web view 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text("WebView Demo")),
        body:  isConnected
          ?  InAppWebView(
      initialUrlRequest:
          URLRequest(url: WebUri.uri(Uri.parse('https://unionlabo.ma'))),

      androidOnGeolocationPermissionsShowPrompt:
          (InAppWebViewController controller, String origin) async {
        return GeolocationPermissionShowPromptResponse(
            origin: origin, allow: true, retain: true);
      },
      androidOnPermissionRequest: (controller, origin, resources) async {
        return null;
      
          
      },
      onLoadStop: (controller, url) async {
        
      },
      initialOptions: InAppWebViewGroupOptions(
        android: AndroidInAppWebViewOptions(
          useWideViewPort: true,
          geolocationEnabled: true,
          allowContentAccess: true,
          allowFileAccess: true,
          safeBrowsingEnabled: true,
        ),
        ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true, sharedCookiesEnabled: true),
      ),

      onWebViewCreated: (controller) async {
      },
    ):
    Center(
      child: NoInternetPage(),
    ),

        );
  }
}



// A simple "No Internet" page
class NoInternetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 80, color: Color.fromARGB(255, 33, 101, 190)),
          SizedBox(height: 20),
          Text(
            "Pas de connexion Internet",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Vérifiez votre connexion et réessayez.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Reload the app
              // ignore: invalid_use_of_protected_member
              (context as Element).reassemble();
            },
            child: Text("Réessayer"),
          ),
        ],
      ),
    );
  }
}
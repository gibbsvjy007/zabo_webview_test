import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class InAppViewPage extends StatefulWidget {
  @override
  _InAppViewPageState createState() => _InAppViewPageState();
}

class _InAppViewPageState extends State<InAppViewPage> {
  InAppWebViewController webView;
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List imageInMemory;

  String hitUrl =
      'https://m.uber.com/looking?drop=%7B%22id%22%3A%22ChIJsbUi45N3AjoR9VdBHymQLiU%22%2C%22addressLine1%22%3A%22Howrah%20Railway%20Station%22%2C%22addressLine2%22%3A%22Howrah%2C%20West%20Bengal%22%2C%22provider%22%3A%22google_places%22%2C%22locale%22%3A%22en%22%2C%22latitude%22%3A22.5830002%2C%22longitude%22%3A88.3372909%7D&pickup=%7B%22id%22%3A%22ChIJmwvh8NKf-DkRdWX0RsGD5gM%22%2C%22addressLine1%22%3A%22Kolkata%20Airport%22%2C%22addressLine2%22%3A%22International%20Airport%2C%20Dum%20Dum%2C%20Kalkutta%2C%20Westbengalen%22%2C%22provider%22%3A%22google_places%22%2C%22locale%22%3A%22de%22%2C%22latitude%22%3A22.643379799999998%2C%22longitude%22%3A88.43889039999999%7D';
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  JavaScriptHandlerCallback onZaboHandlerCallback(List<dynamic> arguments) {
    var data = jsonDecode(arguments[0]['foo']);
    print(data);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Awesome!'),
            content: Text(data.toString().substring(0, 300) + '...'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'))
            ],
          );
        });
    return null;
  }

  Future<Uint8List> _capturePng() async {
    try {
      Uint8List pngData = await webView.takeScreenshot();setState(() {
        imageInMemory = pngData;
      });
      showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Yuppy', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),textAlign: TextAlign.center,)),
          contentPadding: EdgeInsets.all(15.0),
          content:  Container(decoration: BoxDecoration(
              border: Border.all(color: Colors.grey)
          ),
            height: MediaQuery.of(context).size.height - 200,
            width: MediaQuery.of(context).size.width - 30,
//              child: _imageFile != null ? Image.file(_imageFile) : Container(),
            child: imageInMemory != null
                ? Container(
                child: Image.memory(imageInMemory),
                margin: EdgeInsets.all(10))
                : Container(),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'))

          ],
        );
      });
      return pngData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Uber'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text('capture Image'),
            onPressed: _capturePng,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: InAppWebView(
                  initialUrl: hitUrl,
                  initialOptions: {
                    'javaScriptEnabled': true,
                    'supportZoom': true,
//                    "useShouldOverrideUrlLoading": false,
//                    'databaseEnabled': true,
                    "domStorageEnabled": true,
//                    'clearSessionCache': true,
//                    "javaScriptCanOpenWindowsAutomatically": false,
//                    "mixedContentMode": "false"
                    "useOnLoadResource": true,
                  },
                  onLoadStart: (InAppWebViewController controller, String url) {
                    print("started $url");
                  },
                  onWebViewCreated:
                      (InAppWebViewController controller) async {
                    webView = controller;
                    webView.setOptions({'javaScriptEnabled': true});
                    await webView.injectScriptFile("https://code.jquery.com/jquery-3.3.1.min.js");
                    String givenJS = await rootBundle.loadString('assets/zabo1.js');
                    await webView.injectScriptCode(givenJS);
                    webView.addJavaScriptHandler('zaboHandler', onZaboHandlerCallback);
                  },
                  onConsoleMessage: (InAppWebViewController controller,
                      ConsoleMessage consoleMessage) {
                    print(consoleMessage.message);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

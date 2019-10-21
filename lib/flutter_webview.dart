import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class FlutterWebviewPage extends StatefulWidget {
  @override
  _FlutterWebviewPageState createState() => _FlutterWebviewPageState();
}

class _FlutterWebviewPageState extends State<FlutterWebviewPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  String hitUrl =
      'https://m.uber.com/looking?drop=%7B%22id%22%3A%22ChIJsbUi45N3AjoR9VdBHymQLiU%22%2C%22addressLine1%22%3A%22Howrah%20Railway%20Station%22%2C%22addressLine2%22%3A%22Howrah%2C%20West%20Bengal%22%2C%22provider%22%3A%22google_places%22%2C%22locale%22%3A%22en%22%2C%22latitude%22%3A22.5830002%2C%22longitude%22%3A88.3372909%7D&pickup=%7B%22id%22%3A%22ChIJmwvh8NKf-DkRdWX0RsGD5gM%22%2C%22addressLine1%22%3A%22Kolkata%20Airport%22%2C%22addressLine2%22%3A%22International%20Airport%2C%20Dum%20Dum%2C%20Kalkutta%2C%20Westbengalen%22%2C%22provider%22%3A%22google_places%22%2C%22locale%22%3A%22de%22%2C%22latitude%22%3A22.643379799999998%2C%22longitude%22%3A88.43889039999999%7D';
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<String> _onMessage;
  bool invokedAjax = false;

  @override
  void initState() {
    super.initState();
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
       print('onUrlChanged: $url');
       if (!invokedAjax) {
         invokedAjax = true;
         flutterWebviewPlugin.invokeAjaxInterceptor();
        print("AJAX INTERCEPTOR INVOKED_________________");
       }
    });

    _onMessage = flutterWebviewPlugin.onPostMessage.listen((msg) {
      print("MESSAGE INVOKED_________________");
      print(msg);
    });
  }

  @override
  void dispose() {
    super.dispose();
    flutterWebviewPlugin?.close();
    _onUrlChanged?.cancel();
    _onMessage?.cancel()
;  }

  open() async {
//    await loadJS();
    flutterWebviewPlugin.launch(
      hitUrl,
      withLocalStorage: true,
      withJavascript: true,
      clearCache: true,
      appCacheEnabled: true,
      hidden: false,
      rect: Rect.fromLTWH(
        0.0,
        0.0,
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height - 200,
      ),
    );
  }

  Future<void> loadJS() async {
    var givenJS = rootBundle.loadString('assets/zabo_flutter_webview.js');
//    flutterWebviewPlugin.onProgressChanged.listen((message){
//      print(message);
//    });
    return givenJS.then((String js) {
      print('loading js');
      final future = flutterWebviewPlugin.evalJavascript(js);
      future.then((String result) {
        print(result);
      });
//      flutterWebviewPlugin.onStateChanged.listen((viewState) async {
//        print('onStateChanged :_____');
//        print(viewState.url);
//        if (viewState.type == WebViewState.finishLoad) {
//          final future = flutterWebviewPlugin.evalJavascript(js);
//          future.then((String result) {
//            print(result);
////            setState(() {
////              print(result);
////            });
//          });
////          String script =
////              'window.addEventListener("message", receiveMessage, false);' +
////                  'function receiveMessage(event) {Android.getPostMessage(event.data);}';
////          flutterWebviewPlugin.evalJavascript(script);
//        }
//      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: hitUrl,
      primary: true,
      appBar: AppBar(
        title: const Text('Uber'),
      ),
      withZoom: false,
      appCacheEnabled: true,
      withJavascript: true,
      withOverviewMode: true,
      clearCache: true,
      withLocalStorage: true,
      ajaxInterceptor: true,
      initialChild: Container(
        color: Colors.redAccent,
        child: const Center(
          child: Text('Waiting.....'),
        ),
      ),
    );
  }

}

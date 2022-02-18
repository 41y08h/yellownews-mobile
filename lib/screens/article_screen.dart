import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleScreen extends StatelessWidget {
  final String url;
  const ArticleScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Read More'),
      ),
      child: SafeArea(child: WebView(initialUrl: url)),
    );
  }
}

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import 'package:yellow_news/screens/article_screen.dart';

main() {
  runApp(
    MaterialApp(
      title: "Yellow News",
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyText2: TextStyle(
            fontFamily: "PatrickHandSC",
          ),
        ),
      ),
      home: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  dynamic data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final response =
        await http.get(Uri.parse('https://yellownews.herokuapp.com/api'));
    setState(() {
      data = jsonDecode(response.body);
      isLoading = false;
    });
  }

  void openArticle(int index) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) =>
            ArticleScreen(url: data['articles'][index]['url']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
          child: Column(
            children: [
              const Text(
                "Yellow News",
                style: TextStyle(fontSize: 50, color: Color(0xffddcd45)),
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.transparent,
                        ),
                        itemCount: data['articles'].length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Image.network(
                                  data['articles'][index]['urlToImage'],
                                  width: double.infinity,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['articles'][index]['title'],
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      Text(
                                        timeago.format(
                                          DateTime.parse(
                                            data['articles'][index]
                                                ['publishedAt'],
                                          ),
                                        ),
                                      ),
                                      Text(
                                        data['articles'][index]['description'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {
                                            openArticle(index);
                                          },
                                          child: Text("Read More"),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

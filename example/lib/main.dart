import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:dual_refresh_indicator/dual_refresh_indicator.dart';
import 'package:loaded_list_view/loaded_list_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  ScrollController _controller;
  var _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  initState() {
    super.initState();
    _controller = ScrollController();
    _suggestions.clear();
    _suggestions.addAll(generateWordPairs().take(20));
  }

  Widget _buildSuggestions() {
    return LoadedListView.separated(
        controller: _controller,
        itemCount: _suggestions.length,
        padding: const EdgeInsets.all(16.0),
        separatorBuilder: (context, i) => Divider(
              height: 2,
            ),
        itemBuilder: (context, i) {
          return _buildRow(_suggestions[i]);
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }

  Future<void> onTopRefresh() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
    return Future.value();
  }

  Future<void> onBottomRefresh() {
    _controller.jumpTo(_controller.position.minScrollExtent);
    return Future.value();
  }

  // #docregion RWS-build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: DualRefreshIndicator(
        reversed: false,
        onTopRefresh: onTopRefresh,
        onBottomRefresh: onBottomRefresh,
        child: _buildSuggestions(),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

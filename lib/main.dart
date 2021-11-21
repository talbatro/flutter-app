import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

//App class builder
class MyApp extends StatelessWidget {                                           //Stateless indicates no changes possible from user
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {                                          //main function of App
    return MaterialApp(                                                         //describe App functionalities
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: RandomWords(),                                                      //route first displayed when app is turned on
    );
  }
}

class RandomWords extends StatefulWidget {                                      //Stateful because it changes with user input
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {                            //_ implies only available in files where it is defined
  @override

  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};                                                  //set, to avoid duplicates
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget build(BuildContext context) {                                          //build the randomWordGenerator
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          )
        ],
      ),
      body: _buildSuggestions(),                                                //call function to create infinite suggestions
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(                                                    //build the list with text space and dividers
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();
        final index = i ~/ 2;
        if (index >= _suggestions.length) {                                     //if my current index is greater than the current list length
          _suggestions.addAll(generateWordPairs().take(10));                    //add 10 randomly generated word pairs to the suggestions
        }
        return _buildRow(_suggestions[index]);                                  //return the row built
      });
  }

  Widget _buildRow(WordPair pair) {                                             //for each row with word pair
    final alreadySaved = _saved.contains(pair);                                 //check if pair is favorited
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(                                                           //add heart icon to see if pair is saved or not
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      ),
      onTap: () {                                                               //allow user to add/remove word pair
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {                                                           //what happens when heart icon is pressed and pair is added to saved
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
              (pair) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context:context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}

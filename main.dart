import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: const RandomWords(),
    );
  }
}
class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  void _pushSaved() {
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
            context: context,
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

  var actualMode = 1; //1 é visualização em lista, 2 em card

  mudarVisualizacao(actualMode){
    if (actualMode == 1){
      //Modo de visualização em lista
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          final alreadySaved = _saved.contains(_suggestions[index]);

          return _buildRow(_suggestions[index], alreadySaved);
        },
      );
    } else if(actualMode == 2){
      //Modo de visualização em card
      return GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          //final index = i ~/ 2; -> Manter essa linha faz com que os cards se dupliquem
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          final alreadySaved = _saved.contains(_suggestions[index]);
          return Card(
            child: _buildCard(_suggestions[index], alreadySaved),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () {
              setState(() {
                if (actualMode == 1){
                  actualMode = 2;
                } else{
                  actualMode = 1;
                }
              });
            },
            tooltip: 'Change view mode',
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body: mudarVisualizacao(actualMode), //ListView
    );
  }

  Widget _buildRow(WordPair pair, alreadySaved){
    return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
          leading: IconButton(
              icon: Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
                semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
              ),
              onPressed: () {
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(pair);
                  } else {
                    _saved.add(pair);
                  }
                });
              }
          ),
          trailing: IconButton(
            onPressed: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(pair);
                }
                _suggestions.remove(pair);
              });
            },
            icon: const Icon(Icons.delete_forever),
          ),
    );
  }

  Widget _buildCard(WordPair pair, alreadySaved){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        const SizedBox(height: 5,),
        Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        IconButton(
            icon: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null,
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
            ),
            onPressed: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(pair);
                } else {
                  _saved.add(pair);
                }
              });
            }
        ),
        IconButton(
          onPressed: () {
            setState(() {
              if (alreadySaved) {
                _saved.remove(pair);
              }
              _suggestions.remove(pair);
            });
          },
          icon: const Icon(Icons.delete_forever),
        ),
      ],
    );
  }
}


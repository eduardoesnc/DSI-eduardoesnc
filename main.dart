import 'package:flutter/material.dart';
import 'package:first_app/editar.page.dart';
import 'package:first_app/ParPalavra.dart';
import 'package:first_app/ParPalavraRepository.dart';

void main() {
  runApp(const MyApp());
}

class Argumentos {
  final int id;
  final ParPalavraRepository repositorio;
  final ParPalavra palavra;

  Argumentos({
    required this.id,
    required this.repositorio,
    required this.palavra,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const RandomWords(),
        EditarPage.routeName: (context) => const EditarPage(),
      },
    );
  }
}
class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {

  final ParPalavraRepository _suggestions = ParPalavraRepository();
  final _saved = <ParPalavra>{};
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
        itemCount: _suggestions.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;

          final alreadySaved = _saved.contains(_suggestions.index(index));

          return _buildRow(_suggestions.index(index), alreadySaved, index);
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

          final alreadySaved = _saved.contains(_suggestions.index(index));
          return Card(
            child: _buildCard(_suggestions.index(index), alreadySaved, index),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator', style: TextStyle(fontSize: 18,),),
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
            icon: const Icon(Icons.add),
            onPressed: () {
              ParPalavra pair = ParPalavra(palavra: '');
              Navigator.pushNamed(context, '/editar',
                arguments: Argumentos(id: -1, repositorio: _suggestions, palavra: pair),
              ).then((_) => setState((() {})));
            },
            tooltip: 'Add new Pair',
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

  Widget _buildRow(ParPalavra pair, alreadySaved, index){
    return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
          trailing: Wrap(
            children: [
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
                    _saved.remove(pair);
                    _suggestions.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete_forever),
              ),
            ],
          ),
      onTap: () {
        Navigator.pushNamed(context, '/editar',
          arguments: Argumentos(id: index, repositorio: _suggestions, palavra: pair),
        ).then((_) => setState((() {})));
      },
    );
  }

  Widget _buildCard(ParPalavra pair, alreadySaved, index){
    return Container(
      alignment: Alignment.center,
      child: SizedBox.expand(
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/editar',
            arguments: Argumentos(id: index, repositorio: _suggestions, palavra: pair),
          ).then((_) => setState((() {})));
            },
          child: Column(

            children: <Widget>[const SizedBox(height: 5,),
            Text(
              pair.asPascalCase,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            IconButton(
                icon: Icon(
                  alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: alreadySaved ? Colors.red : Colors.black,
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
                  _suggestions.removeAt(index);
                });
              },
              icon: const Icon(Icons.delete_forever, color: Colors.black,),
        ),
        ],
          ),
        ),
      ),
    );
  }
}


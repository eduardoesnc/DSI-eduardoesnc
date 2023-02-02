import 'package:first_app/ParPalavra.dart';
import "package:english_words/english_words.dart";


class ParPalavraRepository{
  final List<ParPalavra> _lista = [];

  ParPalavraRepository() {
    for (int i = 0; i < 20; i++) {
      final palavra = generateWordPairs().take(1).first;
      _lista.add(ParPalavra(
          palavra: palavra.asPascalCase.toString()));
    }
  }

  List<ParPalavra> get lista{
    return _lista;
  }

  int get length {
    return _lista.length;
  }

  index(int i){
    return _lista[i];
  }

  removeAt(int i){
    _lista.removeAt(i);
  }

  editarPar(int i, String newPar){
    _lista[i].editar(newPar);
  }

}
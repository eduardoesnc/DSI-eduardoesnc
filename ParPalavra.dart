class ParPalavra{
  String? _palavra;


  ParPalavra({required String palavra}){
    _palavra = palavra;
  }

  String get palavra{
    return _palavra!;
  }

  editar(String newPar) {
    _palavra = newPar;
  }

  //gambiarra para resolver conflito: The argument type 'ParPalavra' can't be assigned to the parameter type 'String'.
  String get asPascalCase {
    return palavra;
  }

}


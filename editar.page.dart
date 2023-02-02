import 'package:english_words/english_words.dart';
import 'package:first_app/ParPalavra.dart';
import 'package:first_app/main.dart';
import 'package:flutter/material.dart';
import 'package:first_app/ParPalavraRepository.dart';

class EditarPage extends StatefulWidget {
  const EditarPage({Key? key}) : super(key: key);

  static const routeName = '/editar';

  @override
  State<EditarPage> createState() => _EditarPageState();
}

class _EditarPageState extends State<EditarPage> {


  final palavraController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final argumentos =  ModalRoute.of(context)!.settings.arguments as Argumentos;
    ParPalavra? novaPalavra = argumentos.palavra;
    final ParPalavraRepository repositorio = argumentos.repositorio;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit word'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () { Navigator.pop(context); },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 80, left: 40, right: 40,),
        child: Column(
          children: [
            Text(
             'A palavra era ' + novaPalavra.asPascalCase,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: TextField(
                controller: palavraController,
                //autofocus: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Digite a nova palavra",
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8),),),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),


            SizedBox(
              height: 20,
            ),

            Container(
              height: 50,
              width: 200,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: SizedBox.expand(
                child: TextButton(
                  onPressed: () {
                      final palavra = palavraController.text;

                      repositorio.editarPar(argumentos.id, palavra);

                      Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Enviar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
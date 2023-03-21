import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

///
/// Gli argomenti sono in ordine
/// URL
/// Cartella in cui sono scritti/depositati i file di cui viene successivamente passato il nome
/// Nome del file che contiene il body da mandare
/// Nome del file json che contiene gli header della chiamata. Passare "null" se non sono previsti
/// nome File in cui depositare la risposta
/// nome File in cui depositare l'HTTP status
void main(List<String> arguments) async {
  int expectedLen = 3;
  if (arguments.length != expectedLen) {
    print("Mi aspetto $expectedLen argomenti");
    return;
  }
  String url = arguments.first;
  String metodo = arguments[1];
  Directory baseDir = Directory(arguments[2]);
  File bodyFile = File(baseDir.path + Platform.pathSeparator + "body");
  File headerFile = File(baseDir.path + Platform.pathSeparator + "headers");
  File responseFile =
      File(baseDir.path + Platform.pathSeparator + "resbody");
  File httpResponseFile =
      File(baseDir.path + Platform.pathSeparator + "httppath");
  String bodyContent;
  Map<String, String> headers = {};
  if (headerFile.existsSync()) {
    try {
      headers = Map.castFrom(jsonDecode(headerFile.readAsStringSync()));
    } catch (e) {
      print("Errore in lettura file header ${e.toString()}");
      return;
    }
  }
  try {
    bodyContent = bodyFile.readAsStringSync();
  } catch (e) {
    print("Errore in scrittura file ${e.toString()}");
    return;
  }
  Response? response;
  try {
    if(metodo=="PATCH"){
      response = await http.patch(
        Uri.parse(url),
        body: bodyContent,
        headers: headers,
      );
    }
    if(metodo=="POST"){
      response = await http.post(
        Uri.parse(url),
        body: bodyContent,
        headers: headers,
      );
    }
    if(metodo=="GET"){
      response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
    }  
    if(metodo=="DELETE"){
      response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );
    }  
    if(metodo=="PUT"){
      response = await http.put(
        Uri.parse(url),
        body: bodyContent,
        headers: headers,
      );
    }              
  } catch (e) {
    print("Errore in chiamata http ${e.toString()}");
    return;
  }
  if(response == null){
    print("Response null");
    return;
  }
  await responseFile.writeAsString(response.body);
  await httpResponseFile.writeAsString(response.statusCode.toString());
}

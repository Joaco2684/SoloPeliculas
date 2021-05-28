import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/credits_model.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {

  String _apikey    = "092399c2c938c1f4eaff457e6362e805";
  String _url       = "api.themoviedb.org";
  String _languaje  = "es-ES";

  int _popularesPage = 0;
  bool _cargando     = false;

  //Stream
  List<Pelicula> _populares = [];

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  //Insertar info al Stream
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
  
  //Esuchar lo que emita el stream
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;


  void disposeStreams() {
    _popularesStreamController?.close();
  }


  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    //Petición http
    final resp = await http.get( url );
    final decodedData = json.decode(resp.body); //Transforma la respuesta en una Map

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);


    return peliculas.items; //Retorna las peliculas ya mapeadas
  }


  Future<List<Pelicula>> getEnCines() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key' : _apikey,
      'language' : _languaje,
    });

    return await _procesarRespuesta(url);

  }

  Future<List<Pelicula>> getPopulares() async {

    if (_cargando ) return [];

    _cargando = true;

    _popularesPage++;


    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'  : _apikey,
      'language' : _languaje,
      'page'     : _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp); //AGregamos al stream todas las peliculas
    popularesSink( _populares );

    _cargando = false;

    return resp;

    
  }

  Future<List<Actor>> getCast(int peliId ) async {

    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key' : _apikey,
      'language' : _languaje,
    });

    final resp = await http.get(url);
    final decodedData = json.decode( resp.body );


    final cast = new Cast.fromjsonList(decodedData['cast']);


    return cast.actores;


  } 

  Future<List<Credits>> getPeliculasDeActores(int actorId) async {


    final url = Uri.https(_url, '3/person/$actorId/movie_credits', {
      'api_key' : _apikey,
      'language' : _languaje,
    });

    print("Url:" + url.toString());

    final resp = await http.get(url);

    print("Resp:" + resp.toString());

    final decodedData = await json.decode(resp.body); //Transforma la respuesta en una Map

    print("Decoded: " + decodedData.toString());

    final cast = new Credit.fromjsonList(decodedData['cast']);

    print("Casting:" + cast.credits.toString());

    return cast.credits;

  }

  Future<List<Pelicula>> buscarPelicula( String query ) async {

    final url = Uri.https(_url, '3/search/movie', {
      'api_key'  : _apikey,
      'language' : _languaje,
      'query'    : query
    });

    return await _procesarRespuesta(url);

  }
}
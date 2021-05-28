import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/widgets/card_swiper-widget.dart';
import 'package:peliculas/src/widgets/card_swiper_actores.dart';

class ActorDetalle extends StatelessWidget {

  PeliculasProvider peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {

    final Actor actor = ModalRoute.of(context).settings.arguments;

    
    return Scaffold(
      appBar: AppBar(
        title: Text(actor.name),
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 40),
            Text('Peliculas en las que participó:', 
              style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
              ) 
            ),
            SizedBox(height: 40),
            _swiperTarjetas(actor),
          ],
        ),
      ),
    );


  }

  Widget _swiperTarjetas(Actor actor) {

    return FutureBuilder(
      future: peliculasProvider.getPeliculasDeActores(actor.id),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

        if (snapshot.hasData) {
          return CardSwiperActores(credits: snapshot.data);
        } else {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

      },
    );

  }
}
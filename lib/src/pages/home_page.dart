import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delagate.dart';
import 'package:peliculas/src/widgets/card_swiper-widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';


class HomePage extends StatelessWidget {

  PeliculasProvider peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("SoloPeliculas"),
          backgroundColor: Colors.indigoAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon( Icons.search ),
              onPressed: () {
                showSearch(
                  context: context, 
                  delegate: DataSearch()
                );
              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(height: 30.0,),
              Text("En cartelera", 
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold
                ),
              ),
              _swiperTarjetas(),
              SizedBox(height: 30.0,),
              _footer(context),
              SizedBox(height: 5.0,)
              
            ],
          ),
        )


      ),
    );
  }

  Widget _swiperTarjetas() {

    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) { //El sanpchot tiene la lista de peliculas
        

        if (snapshot.hasData) {
          return CardSwiper( peliculas: snapshot.data, );
        } else {
          return Container(
            height: 400.0,
              child: Center(
                child: CircularProgressIndicator()
              )
          );
        }
        
        
        
      },
    );


  }

  Widget _footer(BuildContext context) {

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', 
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ) 
                        ),
          ),       
          SizedBox(height: 15.0,),
         
          StreamBuilder( //Se vuelve a redibujar cuando hayan cambios
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
             
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              
            },
          ),

        ],
      ),
    );

 }

}
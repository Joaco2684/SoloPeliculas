import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;


    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppBar( pelicula ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10.0,),
                _posterTitulo( context, pelicula ),
                _descripcion( pelicula ),
                _crearCasting( context,pelicula ),
              ]
            )
          ),
        ],
      )
    );
  }

  Widget _crearAppBar( Pelicula pelicula ) {

    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        background: FadeInImage(
          image: NetworkImage( pelicula.getBackgroundImg() ),
          placeholder: AssetImage('assets/img/loading.gif'),
          //fadeInDuration: Duration(microseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );

  }

  Widget _posterTitulo( BuildContext context, Pelicula pelicula ) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage( pelicula.getPosterImg() ),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  pelicula.title, 
                  style: Theme.of(context).textTheme.headline6, 
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  pelicula.originalTitle,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.0,),
                Text(
                  pelicula.releaseDate,  
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.0,),
                Row(
                  children: <Widget>[
                    Icon( Icons.star_border_outlined ),
                    Text( pelicula.voteAverage.toString() ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );

  }

  Widget _descripcion( Pelicula pelicula ) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      margin: EdgeInsets.only(top: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Sinopsis", 
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold
            )
          ),
          Container(
            margin: EdgeInsets.only(top: 3.0),
            child: Text (
              pelicula.overview,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );

  }

  Widget _crearCasting( BuildContext context,Pelicula pelicula ) {
     
    final peliProvider = new PeliculasProvider();

    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15.0),
            child: Text('Casting', 
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ) 
                    ),
          ),       
          SizedBox(height: 15.0,),
         
          FutureBuilder(
            future: peliProvider.getCast(pelicula.id),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

              if (snapshot.hasData) {
                 return _crearActoresPageView( context,snapshot.data );
              } else {
                return Center(
                  child: CircularProgressIndicator()
              );
              }   

            },
          ),

        ],
      ),
    );

 }


  Widget _crearActoresPageView (BuildContext context, List<Actor> actores) {

     return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1,
        ),
        itemCount: actores.length,
        itemBuilder: (context, i) {
          return _actorTarjeta(context, actores[i] );
        },

      ),
    );

  }

  Widget _actorTarjeta( BuildContext context, Actor actor ) {
    
    final tajeta = Container(
      margin: EdgeInsets.only(right: 10.0),
      child: Column(  
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage( actor.getFoto() ),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      )
    );

    return GestureDetector(
      child: tajeta,
      onTap: (){
        Navigator.pushNamed(context, 'actor', arguments: actor);
      },
    );
  
  
  }

  
}
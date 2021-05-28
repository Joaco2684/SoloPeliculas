import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/credits_model.dart';



class CardSwiperActores extends StatelessWidget {

  final List<Credits> credits;

  CardSwiperActores({ @required this.credits });

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;
    
    return Container(
      padding: EdgeInsets.only(top: 10.0),

      child: Swiper(
        itemBuilder: (BuildContext context, int index) {

          return Column(
            children: <Widget>[
               ClipRRect(
               borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  image: NetworkImage( credits[index].getCreditsImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                  height: _screenSize.height * 0.50,
                )

               ),
               Text(credits[index].title.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15.0
                      ),
                     overflow: TextOverflow.ellipsis
                    )
            ],
          
          );
           
        },
        itemCount: credits.length,
        itemWidth: _screenSize.width * 0.70, //70% del ancho de la pantalla
        itemHeight: _screenSize.height * 0.60, //45% del alto de la pantalla
        layout: SwiperLayout.STACK,
      )
    );

  }
}

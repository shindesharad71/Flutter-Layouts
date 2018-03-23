import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:layouts/SingleHousePage.dart' show SingleHousePage;

Map data;

class HouseList extends StatelessWidget {

  getData() async {

    var httpClient = new HttpClient();
    var url = 'https://www.anapioficeandfire.com/api/houses';

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) { 
        var json = await response.transform(UTF8.decoder).join();
        data = JSON.decode(json);
      } else {
        print('Error ${response.statusCode}');
      }
    } catch (exception) {
      print('jumped to exception - ${exception}');
    }    
 }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    Card myCard(String houseName, String houseImageUrl) {
      getData();
      List<String> housesNameList = data.keys.toList();
      print(housesNameList[0]);
      return new Card(
          elevation: 5.0,
          child: new InkWell(
            child: new Container(
              alignment: Alignment.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Image.network(
                    houseImageUrl,
                    height: itemHeight - 120,
                    width: itemWidth,
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Center(
                      child: new Text(
                        houseName,
                        style: new TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new SingleHousePage(houseName)),
                  );
            },
          ));
    }

    return new Flexible(
      child: new Container(
          child: new GridView.count(
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              primary: false,
              shrinkWrap: true,
              controller: new ScrollController(keepScrollOffset: false),
              scrollDirection: Axis.vertical,
              childAspectRatio: (itemWidth / 250.0),
              padding: const EdgeInsets.all(10.0),
              children: <Widget>[
            myCard("House Stark",
                'https://vignette.wikia.nocookie.net/gameofthrones/images/8/8a/House-Stark-Main-Shield.PNG/revision/latest/scale-to-width-down/350?cb=20170101103142'),
            myCard("House Arryn",
                'https://vignette.wikia.nocookie.net/gameofthrones/images/1/15/House-Arryn-Main-Shield.PNG/revision/latest/scale-to-width-down/350?cb=20170101094153'),
            myCard(
              "House Tully",
              'https://vignette.wikia.nocookie.net/gameofthrones/images/b/bd/House-Tully-Main-Shield.PNG/revision/latest/scale-to-width-down/350?cb=20170523040648',
            ),
            myCard(
              "House Baratheon",
              'http://awoiaf.westeros.org/images/thumb/2/2d/House_Baratheon.svg/250px-House_Baratheon.svg.png',
            ),
            myCard(
              "House Targaryen",
              'https://vignette.wikia.nocookie.net/gameofthrones/images/4/43/House-Targaryen-Main-Shield.PNG/revision/latest/scale-to-width-down/350?cb=20170510235320',
            ),
            myCard(
              "House Lannister ",
              'https://vignette.wikia.nocookie.net/gameofthrones/images/8/8a/House-Lannister-Main-Shield.PNG/revision/latest/scale-to-width-down/350?cb=20170101095357',
            ),
          ])),
    );
  }
}

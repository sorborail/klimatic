import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../util/utils.dart';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {

  String cityEntered;

  Future goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context).push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new ChangeCity();
    }));
    if (results != null && results.containsKey('enter')) {
      debugPrint(results['enter'].toString());
      cityEntered = results['enter'];
    }
  }

//  void showStuff() async {
//    Map data = await getWeather(appID, defaultCity);
//    print(data.toString());
//  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Klimatic"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: () {goToNextScreen(context);},
          )
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
                "images/umbrella.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
                alignment: Alignment.center,
                repeat: ImageRepeat.noRepeat
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text(
                '${cityEntered == null ? defaultCity : cityEntered}',
                style: cityStyle()
            ),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset("images/light_rain.png"),
          ),

          // Container which will have our weather data
          new Container(
            //margin: const EdgeInsets.fromLTRB(20, 320, 0, 0),
            child: updateTempWidget(cityEntered),
          )
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$appId&units=metric';
    http.Response response = await http.get(apiUrl);
    if (response.statusCode == 200)
      return json.decode(response.body);
    else return null;
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
      future: getWeather(appID, city == null ? defaultCity : city),
      builder: (BuildContext ctx, AsyncSnapshot<Map> snapshot) {
        // where we get all of the json data, we setup widgets and etc.
        if (snapshot.hasData) {
          Map content = snapshot.data;
          debugPrint(snapshot.toString());
          return new Container(
            margin: const EdgeInsets.fromLTRB(30, 250, 0, 0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new ListTile(
                  title: new Text(
                    '${content['main']['temp'].toString()}°C',
                    style: new TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 49.9,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  ),
                  subtitle: ListTile(
                    title: Text(
                      'Humidity: ${content['main']['humidity'].toString()}%\n'
                      'Min: ${content['main']['temp_min'].toString()}°C\n'
                      'Max: ${content['main']['temp_max'].toString()}°C',
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 19,
                          color: Colors.white70
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        } else return new Container(
          child: Text(
            'City not found!',
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 29.9,
                fontWeight: FontWeight.w500,
                color: Colors.red
            ),
          ),
        );
      }
    );
  }
}

class ChangeCity extends StatelessWidget {

  final cityFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.redAccent,
        title: new Text('Change city'),
        centerTitle: true,
      ),
      body: new Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
            color: const Color(0xff7c94b6),
            image: DecorationImage(
              image: ExactAssetImage('images/white_snow.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: new SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(46.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new ListTile(
                  title: new TextField(
                    decoration: new InputDecoration(
                        hintText: 'Enter City'
                    ),
                    controller: cityFieldController,
                    keyboardType: TextInputType.text,
                  ),
                ),
                new ListTile(
                  title: new FlatButton(
                    child: new Text('Get Weather'),
                    color: Colors.redAccent,
                    textColor: Colors.white70,
                    onPressed: () {
                      Navigator.pop(context, {'enter': cityFieldController.text});
                    },
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}


TextStyle cityStyle() {
  return new TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic
  );
}

TextStyle tempStyle() {
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9
  );
}
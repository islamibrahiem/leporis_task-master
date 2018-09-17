import 'package:flutter/material.dart';
import 'src.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SecondPage extends StatefulWidget {
  String movieName;

  SecondPage({this.movieName});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blueAccent,
        title: new Text(
          "Result",
          style: new TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: new FutureBuilder(
        future: getMovie(widget.movieName),
        builder: (context, movie) {
          Map data = movie.data;
          if (movie.hasError) {
            print(movie.error);
            return Text('Failed to get response from the server',
                style: TextStyle(color: Colors.red, fontSize: 30.0));
          } else if (movie.hasData) {
            if (data["total_results"] == 0) {
              // debugPrint('Film Name Not Found');
              return new Center(
                child: new Container(
                  child: new AlertDialog(
                    title: new Text(
                      'No Result',
                      style: new TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    content: new Text(
                      'Movie name not found try again',
                      style: new TextStyle(),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: new Text('ok'))
                    ],
                  ),
                ),
              );
            } else {
              return new Center(
                child: new ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return new Container(
                          child: new Column(
                        children: <Widget>[
                          new Padding(padding: const EdgeInsets.all(4.0)),
                          new Container(
                            color: Colors.lightBlueAccent,
                            margin: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: new InkWell(
                              onTap: () {},
                              child: new Row(
                                children: <Widget>[
                                  new Image.network(
                                      'https://image.tmdb.org/t/p/w92${data["results"][index]["poster_path"]}'),
                                  new Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0)),
                                  new Column(
                                    children: <Widget>[
                                      new Text(
                                        "${data["results"][index]["title"]}",
                                        style: new TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      new Text(
                                        'Release Date :${data["results"][index]["release_date"]}',
                                        style: new TextStyle(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new Padding(padding: const EdgeInsets.all(1.0)),
                        ],
                      ));
                    }),
              );
            }
          } else if (!movie.hasData) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Future<Map> getMovie(String movieName) async {
  String url =
      'https://api.themoviedb.org/3/search/movie?api_key=$key&query=$movieName';
  http.Response response = await http.get(url);
  return json.decode(response.body);
}

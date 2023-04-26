import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final List<Movie> _movies = <Movie>[];

  Future<void> _getMovies() async {
    //final Response response = await get(Uri.parse('https://yts.mx/api/v2/list_movies.json'));

    final Uri uri = Uri(
        scheme: 'https',
        host: 'yts.mx',
        pathSegments: <String>['api', 'v2', 'list_movies.json'],
        queryParameters: <String, String>{'page': '1', 'limit': '40'});

    final Response response = await get(uri);
    //print(response.statusCode);
    final Map<String, dynamic> map = jsonDecode(response.body) as Map<String, dynamic>;
    final Map<String, dynamic> data = map['data'] as Map<String, dynamic>;
    final List<dynamic> movies = data['movies'] as List<dynamic>;

    for (int i = 0; i < movies.length; i++) {
      final Map<String, dynamic> movie = movies[i] as Map<String, dynamic>;
      _movies.add(Movie(
          title: movie['title'] as String,
          image: movie['medium_cover_image'] as String,
          rating: movie['rating'] as num,
          year: movie['year'] as int));
    }

    setState(() {
      //update list
    });
  }

  @override
  void initState() {
    super.initState();
    _getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Center(
          child: Text(
            'Movies',
          ),
        ),
      ),
      body: GridView.builder(
        itemCount: _movies.length,
        itemBuilder: (BuildContext context, int index) {
          final Movie movie = _movies[index];

          return GridTile(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image.network(
                    movie.image,
                  ),
                ),
                GridTileBar(
                  title: Text(
                    '${movie.title} (${movie.year})',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    '${movie.rating}',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}

class Movie {
  Movie({required this.title, required this.image, required this.rating, required this.year});

  final String title;
  final String image;
  final num rating;
  final int year;
}

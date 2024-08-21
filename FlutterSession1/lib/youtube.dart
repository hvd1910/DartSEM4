import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Search',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = "";
  List<dynamic> _videos = [];

  // Hàm gọi API YouTube
  Future<List<dynamic>> fetchYoutubeVideos(String query) async {
    final apiKey = 'AIzaSyBRPfpemyUW3QzmpxR9WJn08GKINqAdEGc'; // Thay YOUR_API_KEY bằng API key của bạn
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse['items'];
    } else {
      throw Exception('Failed to load videos');
    }
  }

  void _search() async {
    setState(() {
      _searchQuery = _controller.text;
    });
    final results = await fetchYoutubeVideos(_searchQuery);
    setState(() {
      _videos = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search for a video',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _search,
              child: Text('Search'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _videos.length,
                itemBuilder: (context, index) {
                  final video = _videos[index];
                  return ListTile(
                    leading: Image.network(video['snippet']['thumbnails']['default']['url']),
                    title: Text(video['snippet']['title']),
                    subtitle: Text(video['snippet']['channelTitle']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
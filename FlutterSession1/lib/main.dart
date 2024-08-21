import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController controller = TextEditingController();
  String  cityName = '';
  String  weatherInfo = '';

  void fetchWeather() async {
    final apiKey = '49daa6040494739995a3a8fa322144ca';
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric&lang=vi';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        weatherInfo =
        'Thời tiết tại $cityName:\n${data['weather'][0]['description']}'
            '\nNhiệt độ: ${data['main']['temp']}\nĐộ ẩm: ${data['main']['humidity']}%';
      });
    } else {
      setState(() {
        weatherInfo = 'Không tìm thấy thông tin thời tiết cho $cityName';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Nhập tên thành phố',
              ),
              onSubmitted: (value) {
                setState(() {
                  cityName = value;
                  fetchWeather();
                });
              },
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  cityName = controller.text;
                  fetchWeather();
                });
              },
              child: Text('Xem dự báo thời tiết'),
            ),
            SizedBox(height: 20),
            Text(
              weatherInfo,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
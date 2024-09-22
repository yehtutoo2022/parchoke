import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'audio_player_screen.dart';
import 'audio_provider.dart';
import 'audio_widget.dart';
import 'model/audio_model.dart';

class AudioListScreen extends StatefulWidget {
  const AudioListScreen({Key? key}) : super(key: key);

  @override
  State<AudioListScreen> createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {
  List<Audio> audioList = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchAudioData();
  }

  //function to get audio from GitHub json file
  Future<void> fetchAudioData() async {
    setState(() {
      isLoading = true;
      errorMessage = null; // Reset error message
    });


    try {
      final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/yehtutoo2022/parchoke/main/audios.json',
      ));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        audioList = jsonList.map((json) => Audio.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load audio data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching audio data: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio List'),
      ),
      body: Column(
        children: [

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : ListView.builder(
              itemCount: audioList.length,
              itemBuilder: (context, index) {
                final audio = audioList[index];
                return ListTile(
                  title: Text(audio.title),
                  subtitle: Text(audio.subtitle),
                  leading: Image.network(
                    audio.thumbnail,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                  ),
                  onTap: () {
                    Provider.of<AudioPlayerProvider>(context, listen: false).init(audio);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AudioPlayerScreen(audio: audio),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          CurrentPlayingWidget(), // Add the current playing widget here
        ],
      ),
    );
  }
}

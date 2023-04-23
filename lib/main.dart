import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
void main(){
 runApp(MaterialApp(home: AntiPanic()));
}

class AntiPanic extends StatefulWidget {
  AntiPanic({super.key});

  @override
  _AntiPanicState createState() => _AntiPanicState();
}

class _AntiPanicState extends State<AntiPanic> {
  late AudioPlayer audioPlayer;
  PlayerState audioPlayerState = PlayerState.stopped;
  String filePath = 'assets/ram.mp3';


  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        audioPlayerState = state;
      });
    });
    playAudio();
  }

  Future<void> playAudio() async {
    try {
      await audioPlayer.setSourceUrl("file://$filePath");
      await audioPlayer.play(UrlSource(filePath));
    } catch (e) {
      print("Error playing audio file: $e");
    }
  }

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Don't Panic!")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              if (audioPlayerState == PlayerState.playing)
                ElevatedButton(
                  child: Text("Stop"),
                  onPressed: () {
                    audioPlayer.stop();
                    setState(() {
                      audioPlayerState = PlayerState.stopped;
                    });
                  },
                ),
              if (audioPlayerState == PlayerState.stopped)
                ElevatedButton(
                  child: Text("Play"),
                  onPressed: () {
                    playAudio();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

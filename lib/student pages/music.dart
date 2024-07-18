import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class HomePageMusic extends StatefulWidget {
  const HomePageMusic({Key? key}) : super(key: key);

  @override
  State<HomePageMusic> createState() => _HomePageMusicState();
}

class _HomePageMusicState extends State<HomePageMusic> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  int? currentIndex;
  List<String> songs = [
    'assets/audio/flight-of-your-muse.mp3',
    'assets/audio/autumn-flight-of-thought.mp3',
    'assets/audio/ambient-music-.mp3',
    'assets/audio/deep-meditation.mp3',
    'assets/audio/deep-relaxation-meditation-nervous-system-healing.mp3',
    'assets/audio/endless-by-prabajithk.mp3',
    'assets/audio/frequency-of-sleep-meditation.mp3',
    'assets/audio/healing-forest.mp3',
    'assets/audio/meditation-peace-love-healing.mp3',
    'assets/audio/meditation-sounds.mp3',
    'assets/audio/meditative-rain.mp3',
    'assets/audio/peaceful-garden-healing-light-.mp3',
    'assets/audio/piano-music-.mp3',
    'assets/audio/relaxing-birds-and-piano.mp3',
    'assets/audio/relaxing-music-part.mp3',
    'assets/audio/relaxing-music.mp3',
    'assets/audio/spiritual-meditation.mp3',
    'assets/audio/spring-breeze-of-meditation-background-music.mp3',
    
  ];

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.setAsset(songs[0]); 
    audioPlayer.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        setState(() {
          currentIndex = null;
        });
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playAudioFile(int index) async {
    currentIndex = index;
    await audioPlayer.setAsset(songs[index]);
    audioPlayer.play();
    setState(() {
      isPlaying = true;
    });
  }

  void playNextSong() {
    if (currentIndex! < songs.length - 1) {
      currentIndex = currentIndex! + 1;
      playAudioFile(currentIndex!);
    }
  }

  void playPreviousSong() {
    if (currentIndex! > 0) {
      currentIndex = currentIndex! - 1;
      playAudioFile(currentIndex!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 193, 225, 236),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: InkWell(
                    onTap: () => playAudioFile(index),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: currentIndex == index ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.music_note),
                          SizedBox(width: 20),
                          Text(
                            'Song ${index + 1}',
                            style: TextStyle(
                              fontSize: 18,
                              color: currentIndex == index ? Colors.white : Colors.black,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.play_arrow),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: playPreviousSong,
                icon: Icon(Icons.skip_previous),
                iconSize: 40,
                color: Colors.black,
              ),
              IconButton(
                onPressed: () async {
                  if (audioPlayer.playing) {
                    audioPlayer.pause();
                    setState(() {
                      isPlaying = false;
                    });
                  } else {
                    audioPlayer.play();
                    setState(() {
                      isPlaying = true;
                    });
                  }
                },
                icon: Icon(
                  isPlaying ? Icons.pause_circle : Icons.play_arrow_outlined,
                  size: 60,
                ),
              ),
              IconButton(
                onPressed: playNextSong,
                icon: Icon(Icons.skip_next),
                iconSize: 40,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

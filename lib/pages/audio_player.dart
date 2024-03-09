import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:lottie/lottie.dart';

class PositionData {
  const PositionData(this.position, this.bufferedPosition, this.duration);

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class AudioPlayerPage extends StatefulWidget {
  final String? currentUser;

  AudioPlayerPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState(currentUser);
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  late String? currentUser;
  String? selectedUser;

  _AudioPlayerPageState(this.currentUser) {
    _saveUser();
  }

  Future<void> _saveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("currentUser", currentUser!);
  }

  final _playlist = ConcatenatingAudioSource(children: [
    AudioSource.uri(Uri.parse('asset:assets/audio/meditation.mp3'),
        tag: MediaItem(
            id: '0',
            title: 'Meditation Track',
            artist: 'AIIMS Rishikesh',
            artUri: Uri.parse('asset:assets/images/aiims-logo.png')))
  ]);

  late AudioPlayer _audioPlayer;

  bool _isPlaying = false;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
                position,
                bufferedPosition,
                duration ?? Duration.zero,
              ));

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();
    _init();

    _audioPlayer.playingStream.listen((playing) {
      setState(() {
        _isPlaying = playing;
      });
    });

    _audioPlayer.positionStream;
    _audioPlayer.bufferedPositionStream;
    _audioPlayer.durationStream;
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(_playlist);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          elevation: 0.0,
          toolbarHeight: 70,
          title: const Text(
            "Button Goes Here",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(textScaleFactor: 1),
                          child: Text(
                            "Hello",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(textScaleFactor: 1),
                          child: Text(
                            "Devsahfjsahdfkashfkjsahfjksahfalhflkshdfksahfsdkhfskjdhfkjdshfksdhfksjdalhfksdhfksdjhfskajhflksdhflksdahfiuwh nvowalsc ualhc .siwkn dkdfbjhfdjhdfshjbhjsfdhjfdsjhfdsjhfdsjsfdjh,dsfhjdfhfdhfdhuifdhufuhfduhfguhfgduihfgugfugfufguhuijrfguhjgrfuhji",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      )
                    ],
                  )),
              Lottie.asset('assets/jsons/audio-animation.json',
                  animate: _isPlaying, height: 300, repeat: true),
              Container(
                padding: EdgeInsets.all(20.0),
                height: 200,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<PositionData>(
                        stream: _positionDataStream,
                        builder: (context, snapshot) {
                          final positionData = snapshot.data;
                          return ProgressBar(
                              timeLabelTextStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              baseBarColor: Color.fromARGB(134, 88, 201, 118),
                              thumbColor: Colors.white,
                              progressBarColor: Color(0xFF58C977),
                              progress: positionData?.position ?? Duration.zero,
                              buffered: positionData?.bufferedPosition ??
                                  Duration.zero,
                              total: positionData?.duration ?? Duration.zero,
                              onSeek: (duration) {
                                _audioPlayer.seek(duration);
                              });
                        }),
                    Controls(
                      audioPlayer: _audioPlayer,
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class Controls extends StatelessWidget {
  const Controls({
    super.key,
    required this.audioPlayer,
  });

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
        stream: audioPlayer.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;

          if (!(playing ?? false)) {
            return Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFF58C9B0)),
                child: IconButton(
                  onPressed: () {
                    audioPlayer.play();
                  },
                  iconSize: 65,
                  color: Colors.white,
                  icon: Icon(Icons.play_arrow_rounded),
                ));
          } else if (processingState != ProcessingState.completed) {
            return Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFF58C9B0)),
                child: IconButton(
                  onPressed: () {
                    audioPlayer.pause();
                  },
                  iconSize: 65,
                  color: Colors.white,
                  icon: Icon(Icons.pause_rounded),
                ));
          }
          return IconButton(
              onPressed: () {},
              iconSize: 80,
              color: Colors.white,
              icon: Icon(Icons.play_arrow_rounded));
        });
  }
}

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/song.dart';
import '../widgets/player_section.dart';
import '../widgets/song_list.dart';

class MediaPlayerScreen extends StatefulWidget {
  const MediaPlayerScreen({Key? key}) : super(key: key);

  @override
  State<MediaPlayerScreen> createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  late AudioPlayer _audioPlayer;
  int _currentSongIndex = 0;
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  final List<Song> songs = [
    Song(
      id: 1,
      title: 'Lofi Study',
      artist: 'FASSounds',
      filePath: 'lofi_study.mp3',
      duration: const Duration(minutes: 2, seconds: 26),
    ),
    Song(
      id: 2,
      title: 'Good Night',
      artist: 'FASSounds',
      filePath: 'good_night.mp3',
      duration: const Duration(minutes: 2, seconds: 27),
    ),
    Song(
      id: 3,
      title: 'Cinematic Time Lapse',
      artist: 'Lexin_Music',
      filePath: 'cinematic_time_lapse.mp3',
      duration: const Duration(minutes: 2, seconds: 15),
    ),
    Song(
      id: 4,
      title: 'Ambient Dreams',
      artist: 'FASSounds',
      filePath: 'ambient_dreams.mp3',
      duration: const Duration(minutes: 3, seconds: 10),
    ),
    Song(
      id: 5,
      title: 'Night Drive',
      artist: 'Lexin_Music',
      filePath: 'night_drive.mp3',
      duration: const Duration(minutes: 2, seconds: 50),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _playerState = state;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _playNext();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSong(int index) async {
    _currentSongIndex = index;
    try {
      String assetPath = 'songs/${songs[index].filePath}';
      print('Attempting to play: $assetPath');

      await _audioPlayer.play(AssetSource(assetPath));

      print('Successfully playing: ${songs[index].title}');
      setState(() {});
    } catch (e) {
      print('Error playing song: $e');
      print('Asset path attempted: songs/${songs[index].filePath}');
    }
  }

  Future<void> _togglePlayPause() async {
    if (_playerState == PlayerState.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  Future<void> _playNext() async {
    if (_currentSongIndex < songs.length - 1) {
      await _playSong(_currentSongIndex + 1);
    } else {
      await _playSong(0);
    }
  }

  Future<void> _playPrevious() async {
    if (_currentSongIndex > 0) {
      await _playSong(_currentSongIndex - 1);
    } else {
      await _playSong(songs.length - 1);
    }
  }

  Future<void> _seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Column(
        children: [
          PlayerSection(
            song: songs[_currentSongIndex],
            isPlaying: _playerState == PlayerState.playing,
            currentPosition: _position,
            duration: _duration,
            onPlayPause: _togglePlayPause,
            onNext: _playNext,
            onPrevious: _playPrevious,
            onSeek: _seekTo,
            formatDuration: _formatDuration,
          ),
          const SizedBox(height: 10),
          Flexible(
            child: SongListWidget(
              songs: songs,
              currentIndex: _currentSongIndex,
              onSongSelected: _playSong,
              formatDuration: _formatDuration,
            ),
          ),
        ],
      ),
    );
  }
}
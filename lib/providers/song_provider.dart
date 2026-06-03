import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class SongProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final OnAudioQuery _audioQuery = OnAudioQuery();

  List<SongModel> _songs = [];
  List<SongModel> get songs => _songs;

  ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: []);
  ConcatenatingAudioSource get playlist => _playlist;

  int? _currentIndex;
  int? get currentIndex => _currentIndex;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  SongProvider() {
    _init();
  }

  void _init() {
    _audioPlayer.currentIndexStream.listen((index) {
      _currentIndex = index;
      notifyListeners();
    });

    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });
  }

  Future<void> fetchSongs() async {
    bool status = await _audioQuery.permissionsStatus();
    if (!status) {
      status = await _audioQuery.permissionsRequest();
    }

    if (status) {
      _songs = await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      _playlist = ConcatenatingAudioSource(
        children: _songs.map((song) => AudioSource.uri(Uri.parse(song.uri!))).toList(),
      );

      await _audioPlayer.setAudioSource(_playlist);
      notifyListeners();
    }
  }

  Future<void> playSong(int index) async {
    await _audioPlayer.seek(Duration.zero, index: index);
    _audioPlayer.play();
  }

  Future<void> pausePlay() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  Future<void> skipToNext() async {
    if (_audioPlayer.hasNext) {
      await _audioPlayer.seekToNext();
    }
  }

  Future<void> skipToPrevious() async {
    if (_audioPlayer.hasPrevious) {
      await _audioPlayer.seekToPrevious();
    }
  }

  void reorderSongs(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    // Update local list
    final SongModel item = _songs.removeAt(oldIndex);
    _songs.insert(newIndex, item);

    // Update playlist in just_audio
    _playlist.move(oldIndex, newIndex);

    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

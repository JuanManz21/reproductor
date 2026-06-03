import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../providers/song_provider.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
      ),
      body: Consumer<SongProvider>(
        builder: (context, songProvider, child) {
          if (songProvider.currentIndex == null) {
            return const Center(child: Text('Nothing playing'));
          }

          final currentSong = songProvider.songs[songProvider.currentIndex!];

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QueryArtworkWidget(
                  id: currentSong.id,
                  type: ArtworkType.AUDIO,
                  artworkHeight: 300,
                  artworkWidth: 300,
                  nullArtworkWidget: const Icon(Icons.music_note, size: 200),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    currentSong.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(currentSong.artist ?? 'Unknown Artist', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 48,
                      icon: const Icon(Icons.skip_previous),
                      onPressed: () => songProvider.skipToPrevious(),
                    ),
                    IconButton(
                      iconSize: 64,
                      icon: Icon(songProvider.isPlaying ? Icons.pause_circle : Icons.play_circle),
                      onPressed: () => songProvider.pausePlay(),
                    ),
                    IconButton(
                      iconSize: 48,
                      icon: const Icon(Icons.skip_next),
                      onPressed: () => songProvider.skipToNext(),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

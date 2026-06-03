import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../providers/song_provider.dart';
import 'now_playing_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SongProvider>(context, listen: false).fetchSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Music'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // Navigation to Reorder screen or show Reorderable list
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReorderSongsScreen()),
              );
            },
          )
        ],
      ),
      body: Consumer<SongProvider>(
        builder: (context, songProvider, child) {
          if (songProvider.songs.isEmpty) {
            return const Center(child: Text('No songs found or permission denied'));
          }

          return ListView.builder(
            itemCount: songProvider.songs.length,
            itemBuilder: (context, index) {
              final song = songProvider.songs[index];
              return ListTile(
                title: Text(song.title),
                subtitle: Text(song.artist ?? 'Unknown Artist'),
                leading: QueryArtworkWidget(
                  id: song.id,
                  type: ArtworkType.AUDIO,
                ),
                onTap: () {
                  songProvider.playSong(index);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NowPlayingScreen()),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ReorderSongsScreen extends StatelessWidget {
  const ReorderSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reorder Songs')),
      body: Consumer<SongProvider>(
        builder: (context, songProvider, child) {
          return ReorderableListView.builder(
            itemCount: songProvider.songs.length,
            onReorder: (oldIndex, newIndex) {
              songProvider.reorderSongs(oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final song = songProvider.songs[index];
              return ListTile(
                key: ValueKey(song.id),
                title: Text(song.title),
                subtitle: Text(song.artist ?? 'Unknown Artist'),
                trailing: const Icon(Icons.drag_handle),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/song.dart';

class SongListWidget extends StatelessWidget {
  final List<Song> songs;
  final int currentIndex;
  final Function(int) onSongSelected;
  final String Function(Duration) formatDuration;

  const SongListWidget({
    Key? key,
    required this.songs,
    required this.currentIndex,
    required this.onSongSelected,
    required this.formatDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0A0A0A),
      child: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          final isCurrentSong = index == currentIndex;

          return GestureDetector(
            onTap: () => onSongSelected(index),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isCurrentSong
                          ? const Color(0x667B3FF2)
                          : const Color(0xFF2A2A2A),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isCurrentSong ? const Color(0xFF7B3FF2) : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          song.artist,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    formatDuration(song.duration),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
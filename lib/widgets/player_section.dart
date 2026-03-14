import 'package:flutter/material.dart';
import '../models/song.dart';

class PlayerSection extends StatelessWidget {
  final Song song;
  final bool isPlaying;
  final Duration currentPosition;
  final Duration duration;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(Duration) onSeek;
  final String Function(Duration) formatDuration;

  const PlayerSection({
    Key? key,
    required this.song,
    required this.isPlaying,
    required this.currentPosition,
    required this.duration,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
    required this.onSeek,
    required this.formatDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Text(
            'Media Player',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white60,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 40),
          // Container(
          //   width: 200,
          //   height: 200,
          //   decoration: BoxDecoration(
          //     color: const Color(0xFF7B3FF2).withOpacity(0.3),
          //     shape: BoxShape.circle,
          //   ),
          //   child: Center(
          //     child: Container(
          //       width: 180,
          //       height: 180,
          //       decoration: const BoxDecoration(
          //         color: Color(0xFF7B3FF2),
          //         shape: BoxShape.circle,
          //       ),
          //       child: const Icon(
          //         Icons.music_note_rounded,
          //         color: Colors.white,
          //         size: 80,
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 40),
          Text(
            song.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            song.artist,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _ProgressSlider(
            currentPosition: currentPosition,
            duration: duration,
            onSeek: onSeek,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDuration(currentPosition),
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                formatDuration(duration),
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ControlButton(
                icon: Icons.skip_previous_rounded,
                onPressed: onPrevious,
              ),
              _PlayButton(
                isPlaying: isPlaying,
                onPressed: onPlayPause,
              ),
              _ControlButton(
                icon: Icons.skip_next_rounded,
                onPressed: onNext,
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ProgressSlider extends StatefulWidget {
  final Duration currentPosition;
  final Duration duration;
  final Function(Duration) onSeek;

  const _ProgressSlider({
    required this.currentPosition,
    required this.duration,
    required this.onSeek,
  });

  @override
  State<_ProgressSlider> createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<_ProgressSlider> {
  late double _sliderValue;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.currentPosition.inMilliseconds.toDouble();
  }

  @override
  void didUpdateWidget(covariant _ProgressSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDragging) {
      _sliderValue = widget.currentPosition.inMilliseconds.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 10,
          elevation: 2,
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 15),
      ),
      child: Slider(
        value: _sliderValue,
        max: widget.duration.inMilliseconds.toDouble(),
        onChanged: (value) {
          setState(() {
            _sliderValue = value;
            _isDragging = true;
          });
        },
        onChangeEnd: (value) {
          widget.onSeek(Duration(milliseconds: value.toInt()));
          setState(() {
            _isDragging = false;
          });
        },
        activeColor: const Color(0xFF7B3FF2),
        inactiveColor: Colors.grey[700],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;

  const _PlayButton({
    required this.isPlaying,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xFF7B3FF2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Icon(
        icon,
        color: Colors.white,
        size: 36,
      ),
    );
  }
}
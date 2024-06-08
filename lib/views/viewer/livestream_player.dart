import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class LivestreamPlayer extends StatefulWidget {
  final String playbackHlsUrl;
  final Orientation orientation;

  final bool showOverlay;

  final Function onPlaybackEnded;
  const LivestreamPlayer({
    Key? key,
    required this.playbackHlsUrl,
    required this.orientation,
    required this.showOverlay,
    required this.onPlaybackEnded,
  }) : super(key: key);

  @override
  LivestreamPlayerState createState() => LivestreamPlayerState();
}

class LivestreamPlayerState extends State<LivestreamPlayer>
    with AutomaticKeepAliveClientMixin {
  late VlcPlayerController _controller;

  //
  double sliderValue = 0.0;
  String position = '';
  String duration = '';
  bool validPosition = false;

  bool isHandRaised = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = VlcPlayerController.network(widget.playbackHlsUrl,
        options: VlcPlayerOptions());
    _controller.addListener(listener);
  }

  @override
  void dispose() async {
    _controller.removeListener(listener);
    _controller.dispose();
    super.dispose();
  }

  void listener() async {
    if (!mounted) return;
    //
    if (_controller.value.isInitialized) {
      var oPosition = _controller.value.position;
      var oDuration = _controller.value.duration;
      if (oPosition != null && oDuration != null) {
        if (oDuration.inHours == 0) {
          var strPosition = oPosition.toString().split('.')[0];
          var strDuration = oDuration.toString().split('.')[0];
          position =
              "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
          duration =
              "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
        } else {
          position = oPosition.toString().split('.')[0];
          duration = oDuration.toString().split('.')[0];
        }
        validPosition = oDuration.compareTo(oPosition) >= 0;
        sliderValue = validPosition ? oPosition.inSeconds.toDouble() : 0;
      }
      if (_controller.value.isEnded) {
        widget.onPlaybackEnded();
      }
      setState(() {});
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Flexible(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Center(
                child: VlcPlayer(
                  controller: _controller,
                  aspectRatio: 16 / 9,
                  placeholder: const Center(child: CircularProgressIndicator()),
                ),
              ),
              if (widget.showOverlay)
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      IconButton(
                        color: Colors.white,
                        icon: _controller.value.isPlaying
                            ? Icon(Icons.pause)
                            : Icon(Icons.play_arrow),
                        onPressed: _togglePlaying,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              position,
                              style: TextStyle(color: Colors.white),
                            ),
                            Expanded(
                              child: Slider(
                                activeColor: Colors.redAccent,
                                inactiveColor: Colors.white70,
                                value: sliderValue,
                                min: 0.0,
                                max: (!validPosition &&
                                        _controller.value.duration == null)
                                    ? 1.0
                                    : _controller.value.duration.inSeconds
                                        .toDouble(),
                                onChanged: validPosition
                                    ? _onSliderPositionChanged
                                    : null,
                              ),
                            ),
                            Text(
                              duration,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: widget.orientation == Orientation.portrait
                            ? Icon(Icons.fullscreen)
                            : Icon(Icons.fullscreen_exit),
                        color: Colors.white,
                        onPressed: () {
                          if (widget.orientation == Orientation.portrait) {
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.landscapeLeft,
                              DeviceOrientation.landscapeRight,
                            ]);
                          } else {
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.portraitUp,
                              DeviceOrientation.portraitDown,
                            ]);
                          }
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _togglePlaying() async {
    _controller.value.isPlaying
        ? await _controller.pause()
        : await _controller.play();
  }

  void _onSliderPositionChanged(double progress) {
    setState(() {
      sliderValue = progress.floor().toDouble();
    });
    //convert to Milliseconds since VLC requires MS to set time
    _controller.setTime(sliderValue.toInt() * 1000);
  }
}

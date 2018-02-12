import 'package:chewie/src/chewie_progress_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'dart:async';

import 'dart:ui';
import 'package:chewie/src/material_controls.dart';
import 'package:chewie/src/cupertino_controls.dart';

class PlayerWithControls extends StatefulWidget {
  final VideoPlayerController controller;
  final Future<dynamic> Function() onExpandCollapse;
  final bool fullScreen;
  final ChewieProgressColors cupertinoProgressColors;
  final ChewieProgressColors materialProgressColors;
  final Widget placeholder;
  final double aspectRatio;
  final bool autoPlay;
  final bool showControls;

  PlayerWithControls({
    Key key,
    @required this.controller,
    @required this.onExpandCollapse,
    @required this.aspectRatio,
    this.fullScreen = false,
    this.showControls = true,
    this.cupertinoProgressColors,
    this.materialProgressColors,
    this.placeholder,
    this.autoPlay,
  })
      : super(key: key);

  @override
  State createState() {
    return new _VideoPlayerWithControlsState();
  }
}

class _VideoPlayerWithControlsState extends State<PlayerWithControls> {
  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return new Center(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        child: new AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: new Container(
            child: new Stack(
              children: <Widget>[
                widget.placeholder ?? new Container(),
                new Hero(
                  tag: controller,
                  child: new AspectRatio(
                    aspectRatio: widget.aspectRatio,
                    child: new VideoPlayer(controller),
                  ),
                ),
                _buildControls(context, controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls(
    BuildContext context,
    VideoPlayerController controller,
  ) {
    return widget.showControls
        ? Theme.of(context).platform == TargetPlatform.android
            ? new MaterialControls(
                controller: controller,
                onExpandCollapse: widget.onExpandCollapse,
                fullScreen: widget.fullScreen,
                progressColors: widget.materialProgressColors,
                autoPlay: widget.autoPlay,
              )
            : new CupertinoControls(
                backgroundColor: new Color.fromRGBO(41, 41, 41, 0.7),
                iconColor: new Color.fromARGB(255, 200, 200, 200),
                controller: controller,
                onExpandCollapse: widget.onExpandCollapse,
                fullScreen: widget.fullScreen,
                progressColors: widget.cupertinoProgressColors,
                autoPlay: widget.autoPlay,
              )
        : new Container();
  }

  @override
  void initState() {
    // Hack to show the video when it starts playing. Should be fixed by the
    // Plugin IMO.
    widget.controller.addListener(_onPlay);

    super.initState();
  }

  void _onPlay() {
    if (widget.controller.value.isPlaying) {
      setState(() {
        widget.controller.removeListener(_onPlay);
      });
    }
  }
}
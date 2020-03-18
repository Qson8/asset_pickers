import 'dart:io';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class MyPlayer extends StatefulWidget {
  final File file;
  @override
  _MyPlayerState createState() => _MyPlayerState();

  MyPlayer({Key key, this.file}) : super(key: key);
}

class _MyPlayerState extends State<MyPlayer> {
  VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      // 播放状态
      ..addListener(() {
        if (_controller != null) {
          final bool isPlaying = _controller.value.isPlaying;
          if (isPlaying != _isPlaying) {
            setState(() {
              _isPlaying = isPlaying;
            });
          }
        }
      })
      // 在初始化完成后必须更新界面
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller.value.isPlaying) {
      _controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    // _controller.play();
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child: _controller.value.initialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

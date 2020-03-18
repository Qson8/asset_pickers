import 'dart:io';
import 'package:flutter/material.dart';
import 'package:asset_pickers/asset_pickers.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List assets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('资源选择器'),
      ),
      body: Container(
        child: ListView(
          children: [
            InkWell(
              onTap: () async {
                List list = await AssetPickers.getAssets();
                setState(() {
                  assets = list;
                });
              },
              child: Container(
                color: Color(0xfff1f1f1),
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(10),
                child: Text(
                  '选择图片',
                  style: TextStyle(color: Colors.lightGreen, fontSize: 16),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                List list = await AssetPickers.getAssets(
                    assetType: AssetsType.videoOnly);
                setState(() {
                  assets = list;
                });
              },
              child: Container(
                color: Color(0xfff1f1f1),
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(10),
                child: Text(
                  '选择视频',
                  style: TextStyle(color: Colors.lightGreen, fontSize: 16),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                List list = await AssetPickers.getAssets(
                    assetType: AssetsType.imageOrVideo);
                setState(() {
                  assets = list;
                });
              },
              child: Container(
                color: Color(0xfff1f1f1),
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(10),
                child: Text(
                  '图片或视频',
                  style: TextStyle(color: Colors.lightGreen, fontSize: 16),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                List list = await AssetPickers.getAssets(
                    assetType: AssetsType.imageAndVideo);
                setState(() {
                  assets = list;
                });
              },
              child: Container(
                color: Color(0xfff1f1f1),
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(10),
                child: Text(
                  '图片和视频',
                  style: TextStyle(color: Colors.lightGreen, fontSize: 16),
                ),
              ),
            ),
            InkWell(
              child: Container(
                color: Color(0xfff4f4f4),
                margin: EdgeInsets.all(10),
                child: Center(
                  child: Wrap(children: <Widget>[
                    for (Map item in assets) _assetWidget(item)
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _assetWidget(Map file) {
    String filePath = file['path'];
    String type = file['type'];

    return Container(
      height: 80,
      width: 80,
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.lightBlue,
          border:
              Border.all(color: Colors.blueAccent.withAlpha(60), width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(1))),
      child: Container(
        child: (type == 'image')
            ? Image.file(File(filePath))
            : MyPlayer(
                file: File(filePath),
              ),
      ),
    );
  }
}

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
        if(_controller != null){
          final bool isPlaying = _controller.value.isPlaying;
          if (isPlaying != _isPlaying) {
              setState(() { _isPlaying = isPlaying; });
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
    if(_controller.value.isPlaying){
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

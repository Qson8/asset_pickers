import 'dart:async';
import 'package:flutter/services.dart';

/// 资源选择类型
enum AssetsType {
  /// 仅图片
  imageOnly,

  /// 仅视频
  videoOnly,

  /// 图片或视频
  imageOrVideo,

  /// 图片和视频
  imageAndVideo,
}

const String assetImageOnly = 'assetImageOnly'; // 仅图片
const String assetVideoOnly = 'assetVideoOnly'; // 仅视频
const String assetImageOrVideo = 'assetImageOrVideo'; // 图片、视频其一
const String assetImageAdnVideo = 'assetImageAndVideo'; // 图片和视频一起

class AssetPickers {
  static const MethodChannel _channel = const MethodChannel('asset_pickers');

  static Future<List> getAssets(
      {AssetsType assetType = AssetsType.imageOnly, int imageCount = 9}) async {
    Map map = {'assetType': getAssetType(assetType)};
    final List assets = await _channel.invokeMethod('get_assets', map);
    return assets;
  }

  static String getAssetType(AssetsType type) {
    switch (type) {
      case AssetsType.videoOnly:
        return assetVideoOnly;
        break;
      case AssetsType.imageOrVideo:
        return assetImageOrVideo;
        break;
      case AssetsType.imageAndVideo:
        return assetImageAdnVideo;
        break;
      default:
        return assetImageOnly;
    }
  }
}

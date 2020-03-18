# asset_pickers

> Plug-in update: iOS has been supported, android to be updated.

Similar to WeChat style of resource selection, support a variety of picture, video combination selection, support compression, preview pictures and video.

类似微信风格资源选取，支持图片、视频多种组合选取 ，支持压缩，预览图片和视频。

> Supported Platforms
> * iOS
> * Android (Ready to update)


## How to Use

#### 1. Depend on it
Add this to your package's pubspec.yaml file:
```
dependencies:
  asset_pickers: ^0.0.3
```

#### 2.  Install it
You can install packages from the command line:
with Flutter:

````
$ flutter pub get
````
Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

#### 3. Import it
Now in your Dart code, you can use:
```dart
import 'package:asset_pickers/asset_pickers.dart';
```

## Plugin instructions

#### 插件调用入口

```dart
static Future<List> getAssets({
      AssetsType assetType = AssetsType.imageOnly,
      int imageCount = 9
})
```

#### 提供4中选取类型
```dart
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
```

1、imageOnly

![仅选择图片](https://img.520lee.com/FgxDfQnJwL2DaSsUIGRBUHHT8ITy)

2、videoOnly

![仅选择视频](https://img.520lee.com/Ftpbj1kTNn0NEgJwafigzDe-Gg9T)

3、imageOrVideo

![选择图片或视频](https://img.520lee.com/FrzxNZ7JnzBjzmlfDPeZzXQ1sK0-)

4、imageAndVideo

![选择图片和视频](https://img.520lee.com/FgBiC1XQYhMZc-ankzzxXfAx7PWG)


### iOS
Add the following entry to your Info.plist file, located in /Info.plist : 

`<key>NSAppTransportSecurity</key> <dict> <key>NSAllowsArbitraryLoads</key> <true/> </dict> <key>NSMicrophoneUsageDescription</key> <string>...</string> <key>NSPhotoLibraryAddUsageDescription</key> <string>...</string> <key>NSCameraUsageDescription</key> <string>...</string> <key>NSPhotoLibraryUsageDescription</key> <string>...</string>`



github地址：https://github.com/Qson8/asset_pickers

了解学习更多关于Flutter技术，欢迎关注公众号: Hi Flutter，个人微信:qiukangsheng

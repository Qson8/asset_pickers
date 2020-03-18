# asset_pickers

> 插件更新说明：iOS已支持，安卓待更新。

类似微信风格资源选取，支持图片、视频多种组合选取 ，支持压缩，预览图片和视频。

## 插件使用说明：

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

![仅选择图片](http://img.520lee.com/FgxDfQnJwL2DaSsUIGRBUHHT8ITy)

2、videoOnly

![仅选择视频](http://img.520lee.com/Ftpbj1kTNn0NEgJwafigzDe-Gg9T)

3、imageOrVideo

![选择图片或视频](http://img.520lee.com/FrzxNZ7JnzBjzmlfDPeZzXQ1sK0-)

4、imageAndVideo

![选择图片和视频](http://img.520lee.com/FgBiC1XQYhMZc-ankzzxXfAx7PWG)

github地址：https://github.com/Qson8/asset_pickers

了解学习更多关于Flutter技术，欢迎关注公众号: Hi Flutter，个人微信:qiukangsheng

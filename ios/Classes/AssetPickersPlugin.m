#import "AssetPickersPlugin.h"
#import "LFImagePickerController/LFImagePickerController.h"

@interface AssetPickersPlugin ()<LFImagePickerControllerDelegate, UIDocumentInteractionControllerDelegate>
@property(copy, nonatomic) FlutterResult result;
@end

@implementation AssetPickersPlugin {
    NSDictionary *_arguments;
    UIViewController *_viewController;
}


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"asset_pickers"
            binaryMessenger:[registrar messenger]];
  UIViewController *viewController =
      [UIApplication sharedApplication].delegate.window.rootViewController;
  AssetPickersPlugin *instance =
      [[AssetPickersPlugin alloc] initWithViewController:viewController];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if (self.result) {
    self.result([FlutterError errorWithCode:@"multiple_request"
                                    message:@"Cancelled by a second request"
                                    details:nil]);
    self.result = nil;
  }

  NSDictionary *dict = call.arguments;
  if ([@"get_assets" isEqualToString:call.method]) {
     NSString *assetType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"assetType"]];

    self.result = result;
    [self handleAssetType:assetType];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
  self = [super init];
  if (self) {
    _viewController = viewController;
  }
  return self;
}

- (void)handleAssetType:(NSString *)assetType {
    
    LFImagePickerController *imagePicker = [[LFImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];//这里设置最大选择数，图片和视频的
    imagePicker.allowTakePicture = NO;
    imagePicker.allowPickingOriginalPhoto = NO;
    
    if([assetType isEqualToString:@"assetImageOnly"]) {
        // 仅图片
        //仅展示图片
        imagePicker.allowPickingType = LFPickingMediaTypePhoto;
    } else if([assetType isEqualToString:@"assetVideoOnly"]) {
        // 仅视频
        ///仅展示视频
        imagePicker.allowPickingType = LFPickingMediaTypeVideo;
    } else if([assetType isEqualToString:@"assetImageOrVideo"]) {
        // 图片或视频
        imagePicker.maxVideosCount = 2;
    } else if([assetType isEqualToString:@"assetImageAdnVideo"]) {
        // 图片和视频
    }
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
                imagePicker.syncAlbum = YES; /** 实时同步相册 */
            }
            imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
            [_viewController presentViewController:imagePicker animated:YES completion:nil];
    
}

/** 处理异常 防止未选时取消，再次点进来 报multiple_request异常 */
- (void)lf_imagePickerControllerDidCancel:(LFImagePickerController *)picker {
    self.result = nil;
    _arguments = nil;
}

- (void)lf_imagePickerController:(LFImagePickerController *)picker didFinishPickingResult:(NSArray <LFResultObject*> *)results;
{
   
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString *originalFilePath = [documentPath stringByAppendingPathComponent:@"original"];
    
    NSFileManager *fileManager = [NSFileManager new];
    if (![fileManager fileExistsAtPath:originalFilePath])
    {
        [fileManager createDirectoryAtPath:originalFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //存放得到的图片和视频的数据的数组
    //imagesArray内的结构 【数据的URL，数据的data】
    NSMutableArray *imagesArray = [NSMutableArray new];
    for (NSInteger i = 0; i < results.count; i++) {
        LFResultObject *result = results[i];
        if ([result isKindOfClass:[LFResultImage class]]) {
            LFResultImage *resultImage = (LFResultImage *)result;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
            NSString *timeString =   [formatter stringFromDate: [NSDate date]];
            timeString = [NSString stringWithFormat:@"%@_%d",timeString,i];
            NSString *path = [originalFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",timeString,(resultImage.subMediaType == LFImagePickerSubMediaTypeGIF ? @"gif":@"jpg")]];
            NSString *imgPath = @"";
            if ([resultImage.originalData writeToFile:path atomically:YES]) {
                imgPath = path;
            }
            [imagesArray addObject:@{@"path":imgPath , @"type":@"image"}];

        } else if ([result isKindOfClass:[LFResultVideo class]]) {
            LFResultVideo *resultVideo = (LFResultVideo *)result;
            [imagesArray addObject:@{@"path":resultVideo.url.description , @"type":@"video"}];
    
        } else {
            /** 无法处理的数据 */
            NSLog(@"%@", result.error);
        }
    }
     self.result(imagesArray);
   
}
@end

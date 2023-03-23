//
//  ViewController.m
//  PAGViewer
//
//  Created by dom on 25/09/2017.
//  Copyright © 2017 idom.me. All rights reserved.
//

#import "ViewController.h"
#import "PAGPlayerView.h"
#import "BackgroundView.h"
#import <libpag/PAGVideoDecoder.h>
#import <libpag/PAGLicenseManager.h>
#import <libpag/PAGFile.h>
#import <libpag/PAGMovie.h>
#import <libpag/PAGMovieExporter.h>
#import <CoreServices/CoreServices.h>
#import <PhotosUI/PhotosUI.h>
#import <libpag/PAGImageLayer.h>

@interface ViewController () <UITabBarControllerDelegate>
@property (strong, nonatomic) PAGPlayerView *playerView;
@property (weak, nonatomic) IBOutlet BackgroundView *bgView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pagFileSegmentedControl;
@property (strong, nonatomic) PAGMovieExporter *exportSession;
@property (strong, nonatomic) UIProgressView *exportProgressView;
@property (strong, nonatomic) NSArray<NSString *> *pagFileNames;
@property (strong, nonatomic) NSArray<NSString *> *replaceMovies;
@end

@interface ViewController (SDKAuth)
- (void)initSDKAuth;
@end
@interface ViewController (ExportVideo) <PAGExportCallback>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tintColor = [UIColor colorWithRed:0.00 green:0.35 blue:0.85 alpha:1.00];
    self.pagFileNames = @[@"3D_BOX_encrypted.pag", @"audio.pag", @"sizhi.pag"];
    // SDK鉴权
    [self initSDKAuth];
    // 添加素材证书
    [self initFileLicense];
    [self configView];
}

- (void)configView {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.playerView = [[PAGPlayerView alloc] initWithFrame:screenBounds];
    self.playerView.userInteractionEnabled = TRUE;
    NSString *pagName = self.pagFileNames[self.pagFileSegmentedControl.selectedSegmentIndex];
    [self.playerView loadPAGAndPlay:pagName];
    [self.view insertSubview:self.playerView aboveSubview:self.bgView];
}

/**
* 使用加密素材时需要添加素材证书，否则会解密失败
*/
- (void)initFileLicense {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"license"];
    PAGLicenseResult result = [PAGLicenseManager AddFileLicense:path];
    if (result == PAGLicenseResultSuccess) {
        NSLog(@"Successfully added license.");
    } else {
        NSLog(@"Failed to add certificate. Path:%@", path);
    }
}

- (IBAction)segementDidChange:(UISegmentedControl *)segment {
    NSString *pagName = self.pagFileNames[self.pagFileSegmentedControl.selectedSegmentIndex];
    [self.playerView loadPAGAndPlay:pagName];
}

- (void)dealloc {
    [self.exportSession cancel];
    self.exportSession = nil;
}

@end

@implementation ViewController (SDKAuth)

/**
* SDK鉴权，建议放在AppDelegate初始化时进行，未鉴权或者鉴权失败会显示水印
*/
- (void)initSDKAuth {
    NSString *sdkLicensePath = @"replace your license path";
    NSString *key = @"replace your key";
    NSString *appID = @"replace your app id";
    // 尝试从网络上更新License。
    NSURL* downloadUrl = [NSURL URLWithString:@"replace your url"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:downloadUrl];
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [data writeToURL:[NSURL fileURLWithPath:sdkLicensePath isDirectory:NO] options:NSDataWritingAtomic error:&error];
        [PAGLicenseManager LoadSDKLicense:sdkLicensePath key:key appID:appID];
    }];
    [dataTask resume];
    // 同时使用本地路径鉴权
    PAGLicenseResult result = [PAGLicenseManager LoadSDKLicense:sdkLicensePath key:key appID:appID];
    NSLog(@"onAuthResult result%d", result);
    if (result == PAGLicenseResultSuccess) {
        return;
    }

}

@end

// 导出相关函数方法
@implementation ViewController (ExportVideo)

/*
 创建一个和画面内容一致的PAGComposition。这里不能直接使用PAGView持有的PAGComposition实例，因为同一个PAGComposition不能同时在多个PAGPlayer、PAGView、PAGMovieExporter中使用。
 */
- (PAGComposition*)createComposition {
  NSString* pagName = self.pagFileNames[self.pagFileSegmentedControl.selectedSegmentIndex];
  NSString* fileName = [pagName substringToIndex:pagName.length - 4];
  NSString* extension = [pagName substringFromIndex:pagName.length - 3];
  NSString* pagPath = [[NSBundle mainBundle] pathForResource:fileName ofType:extension];
  PAGFile* file = [PAGFile Load:pagPath];
  if (file == nil) {
    return nil;
  }
  for (int i = 0; i < self.replaceMovies.count; i++) {
    NSString* moviePath = self.replaceMovies[i];
    PAGMovie* movie = [PAGMovie MakeFromFile:moviePath];
    [file replaceImage:i data:movie];
  }
  return file;
}

/*
 点击导出按钮
 */
- (IBAction)exportVideo:(UIButton*)sender {
  if (self.exportSession != nil) {
    [self.exportSession cancel];
    self.exportSession = nil;
  }
  PAGComposition* exportComposition = [self createComposition];
  if (exportComposition == nil) {
    return;
  }
  // 创建默认导出配置
  PAGExportConfig* config = [PAGExportConfig new];
  // 设置路径
  config.outputPath =
      [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
          stringByAppendingString:@"/tmp.mp4"];
  config.width = exportComposition.width;
  config.height = exportComposition.height;
  config.frameRate = exportComposition.frameRate;
  self.exportSession = [PAGMovieExporter Make:exportComposition config:config callback:self];
  if (self.exportSession != nil) {
    [self.exportSession start];
    [self initProgressView];
  }
}

/// PAGMovieExporter的进度回调，回调在主线程
- (void)onProgress:(CGFloat)progress {
  [self.exportProgressView setProgress:progress];
}


/// PAGMovieExporter的状态回调，回调在主线程
- (void)onStatusChange:(PAGExportStatus)status msgs:(NSArray<NSString*>*)msgs {
  if (status == PAGExportStatusComplete || status == PAGExportStatusFailed ||
      status == PAGExportStatusCanceled) {
    [self.exportProgressView removeFromSuperview];
    self.exportProgressView = nil;
    self.exportSession = nil;
  }
  // 弹出提示框
  if (status == PAGExportStatusComplete) {
    UIAlertController* alert =
        [UIAlertController alertControllerWithTitle:@"导出结束"
                                            message:@""
                                     preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    // 弹出提示框
    [self presentViewController:alert animated:true completion:nil];
  }
}


///  导出进度UI
- (void)initProgressView {
  if (self.exportProgressView != nil) {
    return;
  }
  self.exportProgressView =
      [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
  self.exportProgressView.center = self.view.center;
  [self.view addSubview:self.exportProgressView];
}

@end
@interface ViewController (MovieReplace) <UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate>

@end

@implementation ViewController (MovieReplace)

/*
 点击替换视频按钮
 */
- (IBAction)replaceImage:(UIButton *)sender {
    if (@available(iOS 14, *)) {
        PHPickerConfiguration *configuration = [PHPickerConfiguration new];
        configuration.selectionLimit = [self.playerView numImages];
        configuration.preferredAssetRepresentationMode = PHPickerConfigurationAssetRepresentationModeCurrent;
        PHPickerFilter *videosFilter = [PHPickerFilter videosFilter];
        configuration.filter = [PHPickerFilter anyFilterMatchingSubfilters:@[videosFilter]];
        // 使用配置初始化照片选择控制器
        PHPickerViewController *pickerCro = [[PHPickerViewController alloc] initWithConfiguration:configuration];
        pickerCro.delegate = self;

        [self presentViewController:pickerCro animated:YES completion:nil];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = @[(NSString *)kUTTypeMovie];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSURL *url = info[UIImagePickerControllerMediaURL];
    NSString *fileName = [url lastPathComponent];
    NSURL *newURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:fileName]];
    NSError *error;
    // 拷贝文件到本地
    [[NSFileManager defaultManager] copyItemAtURL:url toURL:newURL error:&error];
    // 替换图片
    [self.playerView replaceMovie:@[newURL.path]];
}

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14)) {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (results.count == 0) {
        return;
    }
    __block NSMutableArray *array = [NSMutableArray arrayWithCapacity:results.count];
    __block UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleLarge)];
    indicator.frame = CGRectMake(0, 0, 1000, 1000);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator startAnimating];
    __block int errorSize = 0;
    for (PHPickerResult *result in results) {
        [result.itemProvider
            loadFileRepresentationForTypeIdentifier:(NSString *)kUTTypeMovie completionHandler:^(NSURL *_Nullable url, NSError *_Nullable error) {
                if (error != nil) {
                    errorSize++;
                } else {
                    // 拷贝文件到本地
                    NSString *fileName = [url lastPathComponent];
                    NSURL *newURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:fileName]];
                    [[NSFileManager defaultManager] copyItemAtURL:url toURL:newURL error:nil];
                    [array addObject:newURL.path];
                }
                if (array.count + errorSize == results.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [indicator stopAnimating];
                        [indicator removeFromSuperview];
                        self.replaceMovies = array;
                        // 替换图片
                        [self.playerView replaceMovie:array];
                    });
                }
            }];
    }
}
@end

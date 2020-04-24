//
//  SAScanCtrl.m
//  SAScan
//
//  Created by 余西安 on 2018/8/17.
//  Copyright © 2018年 yusian. All rights reserved.
//

#import "SAScanCtrl.h"
#import "SAScanView.h"
#import <AVFoundation/AVFoundation.h>

@interface SAScanCtrl ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession  *session;
@property (nonatomic, strong) AVAudioPlayer     *player;
@property (nonatomic, strong) AVCaptureDevice   *device;
@property (nonatomic, strong) SAScanView        *scan;
@property (nonatomic, assign) BOOL              autoPop;
@end

@implementation SAScanCtrl
- (instancetype)initWithBlock:(SAScanBlock)block
{
    if (self = [super init]){
        self.block = block;
        self.navigationItem.title = @"扫一扫";
    }
    return self;
}
- (instancetype)initWithBlock:(SAScanBlock)block autoPop:(BOOL)aBool
{
    if ([self initWithBlock:block]){
        self.autoPop = aBool;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.session = [[AVCaptureSession alloc] init];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized) [self createSessionAttribute];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.bounds;
    
    [self.view.layer insertSublayer:layer atIndex:0];
    self.view.backgroundColor = [UIColor blackColor];
    self.scan = [[SAScanView alloc] initWithFrame:self.view.bounds];
    self.scan.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.scan];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"sascan.bundle/scan" withExtension:@"mp3"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重试"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(startRunning)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (nil == self.device) return;
    if (NO == self.session.running) [self.session startRunning];
    // 未申请授权
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted == NO) return;
            [self createSessionAttribute];
            [self.session startRunning];
        }];
    }
    if (authStatus == AVAuthorizationStatusDenied){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息"
                                                                       message:@"请在手机设置中允许本应用使用系统相机"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scan startAnimation];
    if (NO == self.session.running && self.device){
        [self.session startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.scan stopAnimation];
    [self.session stopRunning];
}
// 设置媒体流属性
- (void)createSessionAttribute
{
    if (self.device == nil) return;
    [self.session addInput:[AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil]];
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];   // 设置代理 在主线程里刷新
    [output setRectOfInterest:CGRectMake(0.12 , 0.12, 0.8, 0.8)];
    [self.session addOutput:output];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
}
/// 输出
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0){
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        [self.player play];
        [self.scan stopAnimation];
        [self.session stopRunning];
        
        NSString *string = metadataObject.stringValue;
        if (self.block) self.block(string);
        if (self.autoPop){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (AVCaptureDevice *)device
{
    if (_device == nil){
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}
- (void)startRunning
{
    [self.scan startAnimation];
    if (self.device){
        [self.session startRunning];
    }
}
@end

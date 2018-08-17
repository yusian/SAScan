//
//  ViewController.m
//  SAScanDemo
//
//  Created by 余西安 on 2018/8/17.
//  Copyright © 2018年 yusian. All rights reserved.
//

#import "ViewController.h"
#import "SAScanCtrl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setBackgroundColor:UIColor.lightGrayColor];
    [button setTitle:@"打开扫描" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    button.bounds = CGRectMake(0, 0, 120, 44);
    button.center = self.view.center;
    [button addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)scan
{
    SAScanCtrl *scan = [[SAScanCtrl alloc] initWithBlock:^(NSString *string) {
        // 处理扫描后的输出结果
        [[[UIAlertView alloc] initWithTitle:@"扫描结果"
                                    message:string
                                   delegate:nil
                          cancelButtonTitle:@"知道了"
                          otherButtonTitles:nil, nil] show];
    }];
    [self.navigationController pushViewController:scan animated:YES];
}
@end

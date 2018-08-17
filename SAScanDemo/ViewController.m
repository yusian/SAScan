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
    self.view.backgroundColor = UIColor.lightGrayColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}

- (void)tap
{
    SAScanCtrl *scan = [[SAScanCtrl alloc] initWithBlock:^(NSString *string) {
        
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:scan];
    [self presentViewController:nav animated:YES completion:nil];
}
@end

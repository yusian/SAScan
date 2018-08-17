//
//  SAScanCtrl.h
//  SAScan
//
//  Created by 余西安 on 2018/8/17.
//  Copyright © 2018年 yusian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SAScanBlock)(NSString *string);
@interface SAScanCtrl : UIViewController
@property (nonatomic, copy) SAScanBlock block;
- (instancetype)initWithBlock:(SAScanBlock)block;
- (instancetype)initWithBlock:(SAScanBlock)block autoPop:(BOOL)aBool;
@end

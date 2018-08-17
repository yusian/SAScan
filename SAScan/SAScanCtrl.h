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

/**
 初始化方法

 @param block 扫描结果Block
 @return 返回控制器实例本身
 */
- (instancetype)initWithBlock:(SAScanBlock)block;

/**
  初始化方法

 @param block 扫描结果Block
 @param aBool 是否自动Pop当前控制器，如果为YES，扫码后自动推出当前控制器
 @return 返回控制器实例本身
 */
- (instancetype)initWithBlock:(SAScanBlock)block autoPop:(BOOL)aBool;
@end

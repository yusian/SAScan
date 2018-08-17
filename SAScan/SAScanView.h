//
//  SAScanView.h
//  SAScan
//
//  Created by 余西安 on 2018/8/17.
//  Copyright © 2018年 yusian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAScanView : UIView
@property (nonatomic, strong) UIImageView *scanLine;
- (void)startAnimation;
- (void)stopAnimation;
@end

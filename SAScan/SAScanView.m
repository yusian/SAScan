//
//  SAScanView.m
//  SAScan
//
//  Created by 余西安 on 2018/8/17.
//  Copyright © 2018年 yusian. All rights reserved.
//

#import "SAScanView.h"
@interface SAScanView ()
@property (nonatomic, strong) UIImageView *scanLine;
@end
@implementation SAScanView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.scanLine = [[UIImageView alloc] initWithImage:self.scanImage];
        [self.scanLine setHidden:YES];
        [self addSubview:self.scanLine];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //非扫码区域半透明
    {
        CGFloat w = self.bounds.size.width * 0.7;
        CGFloat x = (self.bounds.size.width - w) * 0.5;
        CGFloat y = (self.bounds.size.height - w) * 0.5;
        {   // 外围区域填充半透明黑色
            // 设置非识别区域颜色
            CGContextSetRGBFillColor(context, 0, 0, 0, 0.6);
            // 扫码区域上面填充
            CGRect rect = CGRectMake(0, 0, self.frame.size.width, y);
            CGContextFillRect(context, rect);
            // 扫码区域左边填充
            rect = CGRectMake(0, y, x, w);
            CGContextFillRect(context, rect);
            // 扫码区域右边填充
            rect = CGRectMake(x + w, y, x, w);
            CGContextFillRect(context, rect);
            // 扫码区域下面填充
            rect = CGRectMake(0, y + w, self.frame.size.width, self.frame.size.height - y - w);
            CGContextFillRect(context, rect);
        }
        {   // 中间可视区域画边框
            UIColor *whiteColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            CGContextSetStrokeColorWithColor(context, whiteColor.CGColor);
            CGContextSetLineWidth(context, 1);
            CGContextAddRect(context, CGRectMake(x, y, w, w));
            CGContextStrokePath(context);
        }
        {   // 中间可视区域画角框
            CGFloat lineWidth = 4.0f;
            CGFloat angleWidth = 15.0f;
            UIColor *greenColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.8];
            CGContextSetLineWidth(context, lineWidth);
            CGContextSetStrokeColorWithColor(context, greenColor.CGColor);
            // 左上角
            CGContextMoveToPoint(context, x, y + angleWidth);
            CGContextAddLineToPoint(context, x, y);
            CGContextAddLineToPoint(context, x + angleWidth, y);
            // 右上角
            CGContextMoveToPoint(context, x + w - angleWidth, y);
            CGContextAddLineToPoint(context, x + w, y);
            CGContextAddLineToPoint(context, x + w, y + angleWidth);
            // 右下角
            CGContextMoveToPoint(context, x + w, y + w - angleWidth);
            CGContextAddLineToPoint(context, x + w, y + w);
            CGContextAddLineToPoint(context, x + w - angleWidth, y + w);
            // 左下角
            CGContextMoveToPoint(context, x + angleWidth, y + w);
            CGContextAddLineToPoint(context, x, y + w);
            CGContextAddLineToPoint(context, x, y + w - angleWidth);
        }
        CGContextStrokePath(context);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat y = (self.bounds.size.height - width * 0.7) * 0.5;
    self.scanLine.frame = CGRectMake(0, y, width, 12);
}
- (void)startAnimation
{
    CGFloat width = self.bounds.size.width;
    CGFloat y = (self.bounds.size.height - width * 0.7) * 0.5;
    self.scanLine.frame = CGRectMake(0, y, width, 12);
    self.scanLine.hidden = NO;
    [self.scanLine.layer removeAllAnimations];
    [UIView animateWithDuration:2.5 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear animations:^{
        self.scanLine.center = CGPointMake(width * 0.5, y + width * 0.7);
    } completion:^(BOOL finished) {
        if (finished) self.scanLine.center = CGPointMake(width * 0.5, y);
    }];
}
- (void)stopAnimation
{
    self.scanLine.hidden = YES;
    [self.scanLine.layer removeAllAnimations];
}
- (UIImage *)scanImage
{
    NSString *imageBase64 = @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAoAAAAAYCAYAAABqZ0wkAAAEv0lEQVR4AezBMQEAMAgDsFbF5GMVDXw7kgQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOCK5kt08pYNalFoGIhBoZ3//8F2h+ESulTdnEDI84A4gvkTBgrJA8CJiLNiTIwTgHJfgZBn/yUfiZUTwheaM+PA1tsPQLw0VMPyq15cs762Tn7Xqi9x4pj9xSG856vmQGLvjmDGdk7yfWP6idBX/o5jv0cTbILm/VZSsK5mMX3HgG7Gio4+1cLasaE3Y6BEHO48azFyzZ1njsHvvSpePd1veGXXbOZsYf0Zx0zv+f87lP98T/oexagclvAtR/te1cnzbeatBeUxtHB7vpl3nhvb9w2g33/sUsz/xl2sYb2773DNpm7jYGtTfUxok5tZSZbrqaTrN3c3jj4kWkg1nZrPfv4scSLsCuiutNYXo1fXjTlc8uZezvXe3t044s7b/SvgMxcFjLXGTZ4ndL5/sB7v4syFjvk+fOrvt/Azuv/zXjauNmc9p/5TN9+V9j/I3zP59GJo32AkHJNcurQXWSTewgzqBd9kbC20ZlD8Im//au+qON9MtC6PV8a+xUNc8fQ/eYohY+5VHuTLY3hm+SFk5mFjpE8IFceqHZGaye/dV/je4vr9sGM2OXaEMBiMW7n/FXK83KK/SMglyjDK+i2eF09tcPuPBmrm76+vfJz8rj+fmtpXkoPQl177RuoHTqwq9JYKF96QcIu2ixRaRAz97oyyxtJ+Q5gUr3S8rNyLlyr78iWBJzuUICnUCWwJiAJs0Rjirlxbf+hF++wkdsYleKDBBsNZMyKneBq5sywjWibYMU9zSmOVtM9qEMULUgNQnguKBHp11uBYrrH4ZYweoNLvZfXQywjekFBT3BjDVwt1dn0hf37iRrnbrsmCnw6kbxr7oWfAIVETPXjz8X7Uvcw9EbzcrxORPiwNP95lbwydN52mf2hqKCrtvzOpAlp4QVLnUOY4fjIrk1Gn2N9EE/6yOkAQH+EcwgShiRbTuqYZju0TxVpdbP8/5ayaWBH8+Zk9NmBXbSImP5pDXGgIX51v5qbI2/v8Wiudr8SuAKtt0f0Pq3ZIjj0dJdtrxzlaAWSxwcHU67o7gv+2nj5K5X6ofAGQVfrKh0n2f3MQLldfQHUeeKiPLkJoLBvu7I/LBkk8RDI3JHk+hirPEjalA3FZX6Z4PvXyXPBJ9BrzCHroI+EqqzUQwcrrgVGrH+oC72gsCf8FU58mYgoYAeZW7/EhFfUfABKX/Q/eo7X1erNCBbi23/Kx7d52vu4x4ycr7lbubJMrPlKFDXlosZ+eayFzWW1gZx0EvBcsF+qc8+Tgqmi+RBwdg3gpAUjsBeF1rUdO0+Xv+MaBCupr/CUPfJbopFVkQhaAkU3CDcsv30t/AS8dIY8G5Yh46QngerNCMJltfBewbgCOIl0krb4hqMKMkQtrg1nHeskbf2a07HV6HcY9HqCZe20BqJf0HMFl7f0W9QydfKM//NLaOzEYiwmr9/d7H4SuvojgY6MuJtfLstc4ezwxIo43cPOvHTsgAQAAgRio9g9tCkH4uxRj/NRZBxAAgCkAAAQgAAACEAAAAQgAgAAEADiBAAQAQAACACAAAQAQgAAALOIkkzC3kTz8AAAAAElFTkSuQmCC";
    NSURL *url = [NSURL URLWithString:imageBase64];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:data];
}
@end

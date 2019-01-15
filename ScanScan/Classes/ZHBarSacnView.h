//
//  ZHBarSacnView.h
//
//  Created by Lee on 2017/9/18.
//  Copyright © 2017年 CoderApple. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ZHBarSacnView : UIView
- (instancetype)initWithFrame:(CGRect)frame scanRect:(CGRect)scanRect;

@property (nonatomic, strong) UIColor *aroundLineColor;
@property (nonatomic, strong) UIColor *cornerLineColor;
@property (nonatomic, strong) UIColor *animatedLineColor;
@property (nonatomic, copy) NSString *hitText;
@property (nonatomic, copy) NSDictionary<NSAttributedStringKey, id> *hitTextAttributes;
@property (nonatomic, copy) void(^choosePicture)(UIButton *sender);
@end


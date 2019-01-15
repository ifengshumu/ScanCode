//
//  UIView+MethodExtend.h
//  ZHUIKit
//
//  Created by 李志华 on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MethodExtend)
/**
 控件顶部,即y坐标
 */
@property (nonatomic, assign) CGFloat top;

/**
 控件底部,即y坐标+高
 */
@property (nonatomic, assign) CGFloat bottom;

/**
 控件左侧,即x坐标
 */
@property (nonatomic, assign) CGFloat left;

/**
 控件右侧,即x坐标+宽
 */
@property (nonatomic, assign) CGFloat right;

/**
 控件Center X
 */
@property (nonatomic, assign) CGFloat centerX;

/**
 控件Center Y
 */
@property (nonatomic, assign) CGFloat centerY;

/**
 控件(x, y)
 */
@property (nonatomic, assign) CGPoint origin;

/**
 控件(width, height)
 */
@property (nonatomic, assign) CGSize size;

/**
 控件宽
 */
@property (nonatomic, assign) CGFloat width;

/**
 控件高
 */
@property (nonatomic, assign) CGFloat height;

- (void)addUnderLine;

@end


//
//  UIView+SegmentBar.m
//  XMGSegmentBar
//
//  Created by 李小南 on 2017/4/20.
//  Copyright © 2017年 李小南. All rights reserved.
//

#import "UIView+SegmentBar.h"

@implementation UIView (SegmentBar)

- (void)setSegmentBar_centerX:(CGFloat)segmentBar_centerX
{
    CGPoint center = self.center;
    center.x = segmentBar_centerX;
    self.center = center;
}

- (CGFloat)segmentBar_centerX
{
    return self.center.x;
}

- (void)setSegmentBar_centerY:(CGFloat)segmentBar_centerY
{
    CGPoint center = self.center;
    center.y = segmentBar_centerY;
    self.center = center;
}

- (CGFloat)segmentBar_centerY
{
    return self.center.y;
}


- (void)setSegmentBar_x:(CGFloat)segmentBar_x
{
    CGRect frame = self.frame;
    frame.origin.x = segmentBar_x;
    self.frame = frame;
}

- (CGFloat)segmentBar_x
{
    return self.frame.origin.x;
}

- (void)setSegmentBar_y:(CGFloat)segmentBar_y
{
    CGRect frame = self.frame;
    frame.origin.y = segmentBar_y;
    self.frame = frame;
}

- (CGFloat)segmentBar_y
{
    return self.frame.origin.y;
}

- (void)setSegmentBar_width:(CGFloat)segmentBar_width
{
    CGRect frame = self.frame;
    frame.size.width = segmentBar_width;
    self.frame = frame;
}

- (CGFloat)segmentBar_width
{
    return self.frame.size.width;
}

- (void)setSegmentBar_height:(CGFloat)segmentBar_height
{
    CGRect frame = self.frame;
    frame.size.height = segmentBar_height;
    self.frame = frame;
}

- (CGFloat)segmentBar_height
{
    return self.frame.size.height;
}


@end

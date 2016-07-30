//
//  JLBallView.m
//  UIdynamicDemo
//
//  Created by DEMO on 16/3/11.
//  Copyright © 2016年 DEMO. All rights reserved.
//

#import "JLDynamicItemView.h"

@implementation JLDynamicItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIDynamicItemCollisionBoundsType)collisionBoundsType {
    return UIDynamicItemCollisionBoundsTypeEllipse;
}

@end

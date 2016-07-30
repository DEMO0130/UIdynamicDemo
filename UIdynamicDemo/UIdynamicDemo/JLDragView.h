//
//  JLDragView.h
//  UIdynamicDemo
//
//  Created by DEMO on 16/3/17.
//  Copyright © 2016年 DEMO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JLDragViewState) {
    JLDragViewStateUnSign = 1,
    JLDragViewStateSigned = 2
};

@interface JLDragView : UIView

/**
 *  签到状态
 */
@property (nonatomic, assign) JLDragViewState signState;

@end

//
//  JLDragView.m
//  UIdynamicDemo
//
//  Created by DEMO on 16/3/17.
//  Copyright © 2016年 DEMO. All rights reserved.
//

#import "JLDragView.h"

//拖动View的图片
static NSString * const dragImageName  = @"Register_Supplier";
//固定View的图片
static NSString * const fixedImageName = @"Register_Client";
//拖动图片的size
static int const kDragViewWidth = 50;
//回滚动画的时间
static CGFloat const kDragViewBackDuration = 0.5f;
//消失动画的时间
static CGFloat const kDragViewHideDuration = 0.5f;
//抖动动画的时间
static CGFloat const kFixedViewShakeDuration = 0.2f;
//抖动角度
static CGFloat const kFixedViewShakeAngle = 5.0f;

@interface JLDragView()

{
    int _dragViewWidth;
    
    //拖动View的初始center
    CGPoint _dragViewCenter;
    //固定View的初始center
    CGPoint _fixedViewCenter;
}
//拖动View实例
@property (nonatomic, strong) UIImageView * dragView;
//固定View实例
@property (nonatomic, strong) UIImageView * fixedView;
//拖动手势
@property (nonatomic, strong) UIPanGestureRecognizer * drag;


@end

@implementation JLDragView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        
        _dragViewWidth = ceil(frame.size.height / 3);
        _dragViewWidth = kDragViewWidth;
        
        CGFloat centerY = CGRectGetMidX(frame) - _dragViewWidth/2;
        
        self.dragView  = [[UIImageView alloc] initWithFrame:CGRectMake(_dragViewWidth, centerY,
                                                                       _dragViewWidth, _dragViewWidth)];
        
        self.fixedView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bounds) - _dragViewWidth * 2, centerY,
                                                                       _dragViewWidth, _dragViewWidth)];
        
        
        self.dragView.image  = [UIImage imageNamed:dragImageName];
        self.fixedView.image = [UIImage imageNamed:fixedImageName];
        
        self.dragView.contentMode  = UIViewContentModeScaleAspectFill;
        self.fixedView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.dragView.clipsToBounds = YES;
        self.fixedView.clipsToBounds = YES;
        
        self.dragView.layer.cornerRadius = _dragViewWidth / 2.0;
        self.fixedView.layer.cornerRadius = _dragViewWidth / 2.0;
        
        self.dragView.userInteractionEnabled = YES;
        
        [self addSubview:self.fixedView];
        [self addSubview:self.dragView];
        
        _dragViewCenter = self.dragView.center;
        _fixedViewCenter = self.fixedView.center;
        
        _signState = JLDragViewStateUnSign;
        
        //手势
        self.drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
        [self.dragView addGestureRecognizer:self.drag];
        
    }
    
    return self;

}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)gesture
{
    
    CGPoint location = [gesture locationInView:self];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
           
        }
            break;
        case UIGestureRecognizerStateChanged: {
            self.dragView.center = CGPointMake(location.x, self.dragView.center.y);
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if (!CGRectContainsPoint(self.fixedView.frame, self.dragView.center)) {
                self.signState = JLDragViewStateUnSign;
            } else {
                self.signState = JLDragViewStateSigned;
            }
        }
            break;
        default: {
            
        }
            break;
    }
}

- (void)setSignState:(JLDragViewState)signState {
    
    _signState = signState;
    
    if (_signState == JLDragViewStateSigned) {
        [self.dragView removeGestureRecognizer:self.drag];
        self.dragView.center = _fixedViewCenter;
        
        //拖动view的消失动画
        [self hideDragViewWithAnimation];
        
    } else {
        //拖动View的回滚动画
        [self backDragViewWithAnimation];
    }

}

- (void)backDragViewWithAnimation {
    
    CGFloat backDistance = _dragViewCenter.x - self.dragView.center.x;
    CGFloat backAngle = backDistance / (kDragViewWidth/2);
    
    int piCount = backAngle / (-M_PI*2);
    
    if (piCount == 0) { piCount = 1; }
    
    backAngle = piCount * (-M_PI*2);
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: backAngle];
    rotationAnimation.duration = kDragViewBackDuration;
    
    
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    moveAnimation.toValue = [NSNumber numberWithFloat:backDistance];
    moveAnimation.duration = kDragViewBackDuration;

    
    CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc] init];
    animationGroup.duration            = kDragViewBackDuration;
    animationGroup.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.animations          = @[rotationAnimation,moveAnimation];
    animationGroup.delegate            = self;
    animationGroup.removedOnCompletion = YES;
    
    
    [self.dragView.layer addAnimation:animationGroup forKey:@"group"];

}

- (void)hideDragViewWithAnimation {
    
    [UIView animateWithDuration:kDragViewHideDuration animations:^{
        self.dragView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self shakeDragViewAnimation];
    }];

}

- (void)shakeDragViewAnimation {
    double angle1 = -kFixedViewShakeAngle / 180.0 * M_PI;
    double angle2 = kFixedViewShakeAngle / 180.0 * M_PI;
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animation];
    shakeAnimation.keyPath = @"transform.rotation";
    shakeAnimation.values = @[@(angle1), @(angle2), @(0)];
    shakeAnimation.duration = kFixedViewShakeDuration;
    shakeAnimation.repeatCount = 4;
    shakeAnimation.removedOnCompletion = NO;
    shakeAnimation.fillMode = kCAFillModeForwards;
    [self.fixedView.layer addAnimation:shakeAnimation forKey:@"shake"];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    self.dragView.center = _dragViewCenter;
}

@end

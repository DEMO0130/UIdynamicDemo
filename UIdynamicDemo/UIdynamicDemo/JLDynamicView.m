//
//  JLDynamicView.m
//  UIdynamicDemo
//
//  Created by DEMO on 16/3/11.
//  Copyright © 2016年 DEMO. All rights reserved.
//

#import "JLDynamicView.h"
#import "JLDynamicItemView.h"

//拿球起始最小力度
static const CGFloat kThrowingThreshold = 50;

//投掷力比例
static const CGFloat kThrowingVelocityPadding = 200;

//篮筐厚
static const CGFloat kCollisionViewHeight = 20;
//篮筐宽
static const CGFloat kCollisionViewDistance = 100;
@interface JLDynamicView()
{
    /**
     *  吸附动效
     */
    UIAttachmentBehavior * _attachmentBehavior;
    
    /**
     *  重力效果
     */
    UIGravityBehavior * _gravityBehavior;
    
    /**
     *  碰撞效果
     */
    UICollisionBehavior * _collisionBehavior;
    
    /**
     *  投掷效果
     */
    UIPushBehavior * _pushBehavior;
    
    /**
     *  动效item
     */
    UIDynamicItemBehavior * _itemBehavior;
    
    /**
     *  动效器
     */
    UIDynamicAnimator * _animator;
    
    /**
     *  视图中心点
     */
    CGPoint _centerPoint;
}
@property (nonatomic, strong) JLDynamicItemView * viewBall;

@property (nonatomic, strong) UIView * leftView;

@property (nonatomic, strong) UIView * rightView;

@property (nonatomic, strong) UIView * midView;
@end


@implementation JLDynamicView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.viewBall = ({
            JLDynamicItemView * view = [[JLDynamicItemView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            view.backgroundColor = [UIColor redColor];
            
            CAShapeLayer * layerBall = [[CAShapeLayer alloc] init];
            UIBezierPath * pathBall = [UIBezierPath bezierPathWithOvalInRect:view.bounds];
            layerBall.path = pathBall.CGPath;
            view.layer.mask = layerBall;
            
            view;
        });
        
        _centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        CGPoint rightPoint = CGPointMake(CGRectGetMaxX(self.bounds), _centerPoint.y);
        
        self.leftView = ({
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(rightPoint.x - 2 * kCollisionViewHeight - kCollisionViewDistance,
                                                                     _centerPoint.y,
                                                                     kCollisionViewHeight,
                                                                     kCollisionViewHeight)];
            view.backgroundColor = [UIColor blueColor];
            view;
        });
        
        self.midView = ({
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(rightPoint.x - kCollisionViewHeight - kCollisionViewDistance,
                                                                     _centerPoint.y,
                                                                     kCollisionViewDistance,
                                                                     kCollisionViewHeight)];
            view.backgroundColor = [UIColor blueColor];
            view;
        });
        
        
        self.rightView = ({
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(rightPoint.x - kCollisionViewHeight,
                                                                     _centerPoint.y,
                                                                     kCollisionViewHeight,
                                                                     kCollisionViewHeight)];
            view.backgroundColor = [UIColor blueColor];
            view;
        });
    
        self.backgroundColor = [UIColor grayColor];
        [self addSubview:self.viewBall];
        [self addSubview:self.rightView];
        [self addSubview:self.midView];
        [self addSubview:self.leftView];
        
        //手势
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
        [self addGestureRecognizer:pan];
        
        
        
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        
        //重力
        _gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.viewBall]];
        
        //碰撞
        _collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.viewBall, self.rightView, self.leftView]];
        _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        
        __weak typeof(self) weakSelf = self;
        
        //赋予球视图一些基本属性
        _itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.viewBall]];
        _itemBehavior.friction = 1;
        _itemBehavior.density = 3.0f;
        _itemBehavior.elasticity = 0.5f;
        _itemBehavior.allowsRotation = YES;
        _itemBehavior.action = ^{
            if (CGRectContainsPoint(weakSelf.midView.frame, weakSelf.viewBall.center)) {
                NSLog(@"bingo");
            }
        };
        
        //赋予篮筐一些基本属性
        UIDynamicItemBehavior * hoopItem = [[UIDynamicItemBehavior alloc] initWithItems:@[self.rightView, self.leftView]];
        hoopItem.density = 10.0f;
        hoopItem.allowsRotation = NO;
        hoopItem.anchored = YES;
        
        
        [_animator addBehavior:_itemBehavior];
        [_animator addBehavior:hoopItem];
        [_animator addBehavior:_gravityBehavior];
        [_animator addBehavior:_collisionBehavior];
        
    }
    return self;
}



- (void)panGestureRecognizer:(UIPanGestureRecognizer *)gesture
{
    
    CGPoint location = [gesture locationInView:self];
    CGPoint imageLocation = [gesture locationInView:self.viewBall];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
//            NSLog(@"touch position %@",NSStringFromCGPoint(location));
//            NSLog(@"loction in image %@",NSStringFromCGPoint(imageLocation));
            
            //移除之前的吸附效果
            [_animator removeBehavior:_attachmentBehavior];
            
            UIOffset centerOffset = UIOffsetMake(imageLocation.x - CGRectGetMidX(self.viewBall.bounds),
                                                 imageLocation.y - CGRectGetMidY(self.viewBall.bounds));
            _attachmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:self.viewBall offsetFromCenter:centerOffset
                                                           attachedToAnchor:location];
            [_animator addBehavior:_attachmentBehavior];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [_animator removeBehavior:_attachmentBehavior];
            
            CGPoint velocity = [gesture velocityInView:self];
            CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
            
            //当投掷力度大于 最低阈值，加投掷效果
            if (magnitude > kThrowingThreshold) {
                _pushBehavior = [[UIPushBehavior alloc]
                                 initWithItems:@[self.viewBall]
                                 mode:UIPushBehaviorModeInstantaneous];
                
                //投掷方向
                _pushBehavior.pushDirection = CGVectorMake((velocity.x / 10) , (velocity.y / 10));
                //投掷力度
                _pushBehavior.magnitude = magnitude / kThrowingVelocityPadding;
                
                [_animator addBehavior:_pushBehavior];
                
            }
            
        }
            break;
        default:
        {
            [_attachmentBehavior setAnchorPoint:[gesture locationInView:self]];
        }
            break;
    }
}

@end

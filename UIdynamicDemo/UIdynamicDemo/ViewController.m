//
//  ViewController.m
//  UIdynamicDemo
//
//  Created by DEMO on 16/3/10.
//  Copyright © 2016年 DEMO. All rights reserved.
//

#import "ViewController.h"

#import "JLDynamicView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    JLDynamicView * dynamic = ({
        JLDynamicView * view = [[JLDynamicView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2)];
        
        view;
    });
    
    
    [self.view addSubview:dynamic];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  SecondVC.m
//  UIdynamicDemo
//
//  Created by DEMO on 16/7/30.
//  Copyright © 2016年 DEMO. All rights reserved.
//

#import "SecondVC.h"

#import "JLDragView.h"

@interface SecondVC ()

@end

@implementation SecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    JLDragView * dragView = ({
        JLDragView * view = [[JLDragView alloc] initWithFrame:CGRectMake(0, 100,  [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2)];
        
        view;
    });
    
    [self.view addSubview:dragView];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

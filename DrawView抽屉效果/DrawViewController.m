//
//  DrawViewController.m
//  DrawView抽屉效果
//
//  Created by 光 on 15/12/1.
//  Copyright © 2015年 光. All rights reserved.
//

#import "DrawViewController.h"

@interface DrawViewController ()
{
    UIView *mainView;
    UIView *leftView;
    UIView *rightView;
}


@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.添加子视图
    [self configChlidView];
    
    // 2.监听
    [mainView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%@", NSStringFromCGRect(mainView.frame));
    
    if (mainView.frame.origin.x < 0) {// 左移
        // 显示右边view
        rightView.hidden = NO;
        leftView.hidden = YES;
    } else if (mainView.frame.origin.x > 0) {// 右移
        // 显示左边view
        leftView.hidden = NO;
        rightView.hidden = YES;
    }
}

#pragma mark - 1.创建左、中、右view
- (void)configChlidView
{
    CGRect frame = self.view.frame;
    leftView = [[UIView alloc] initWithFrame:frame];
    leftView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:leftView];
    
    rightView = [[UIView alloc] initWithFrame:frame];
    rightView.backgroundColor = [UIColor redColor];
    [self.view addSubview:rightView];
    
    mainView = [[UIView alloc] initWithFrame:frame];
    mainView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:mainView];
    
}

#pragma mark - 2.触摸移动响应
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 获取UITouch对象
    UITouch *touch = [touches  anyObject];
    
    // 获取当前点 以及 上一个点 ， 并计算两点的偏移量
    CGPoint point = [touch locationInView:self.view];
    CGPoint prePoint = [touch previousLocationInView:self.view];
    
    CGFloat offsetX = point.x - prePoint.x;
    
    // 获取主视图的frame
    CGRect frame = mainView.frame;
    frame.origin.x += offsetX;
    mainView.frame = frame;
    
}

#pragma mark - 3.当手指偏移，根据x轴的偏移量算出当前主视图的frame
- (void)getCurrentFrameWithOffsetX:(CGFloat)OffsetX
{
    
}







@end

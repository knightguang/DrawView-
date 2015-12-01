//
//  DrawViewController.m
//  DrawView抽屉效果
//
//  Created by 光 on 15/12/1.
//  Copyright © 2015年 光. All rights reserved.
//

#import "DrawViewController.h"

@interface DrawViewController ()

@property (nonatomic, assign) BOOL isTarget;

@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.添加子视图
    [self configChlidView];
    
    // 2.监听
    [_mainView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    NSLog(@"%@", NSStringFromCGRect(mainView.frame));
    
    if (_mainView.frame.origin.x < 0) {// 左移
        // 显示右边view
        _rightView.hidden = NO;
        _leftView.hidden = YES;
    } else if (_mainView.frame.origin.x > 0) {// 右移
        // 显示左边view
        _leftView.hidden = NO;
        _rightView.hidden = YES;
    }
}

#pragma mark - 1.创建左、中、右view
- (void)configChlidView
{
    CGRect frame = self.view.frame;
    UIView *leftView = [[UIView alloc] initWithFrame:frame];
    leftView.backgroundColor = [UIColor blueColor];
    _leftView = leftView;
    [self.view addSubview:_leftView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:frame];
    rightView.backgroundColor = [UIColor redColor];
    _rightView = rightView;
    [self.view addSubview:_rightView];
    
    UIView *mainView = [[UIView alloc] initWithFrame:frame];
    mainView.backgroundColor = [UIColor grayColor];
    _mainView = mainView;
    [self.view addSubview:_mainView];
    
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
//    CGRect frame = mainView.frame;
//    frame.origin.x += offsetX;
    _mainView.frame = [self getCurrentFrameWithOffsetX:offsetX];
    
    _isTarget = YES;;
    
}


#pragma mark - 3.当手指偏移，根据x轴的偏移量算出当前主视图的frame
- (CGRect)getCurrentFrameWithOffsetX:(CGFloat)OffsetX
{
    
    
    // 获取y轴偏移量，手指每移动一点，y轴偏移多少
    CGFloat offsetY = OffsetX / kScreenW * kMaxY;
    
    CGFloat scale = (kScreenH - 2 * offsetY) / kScreenH;
    
    if (_mainView.frame.origin.x < 0) {
        // 往左滑
        scale = (kScreenH + 2 * offsetY) / kScreenH;
    }
    
    // 获取之前的frame
    CGRect frame = _mainView.frame;
    frame.origin.x += OffsetX;
    frame.size.height = frame.size.height * scale;
    frame.size.width = frame.size.width * scale;
    frame.origin.y = (kScreenH - frame.size.height) * 0.5;
    
    return frame;
}

/**
 *  mainView.frame.origin.x > 屏幕一半  定位到右边
 *  CGRectGetMaxX(mainView.frame) < 屏幕一半  定位到左边
 */

#pragma mark - 定位与复位
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 复位
    if (_isTarget == NO && _mainView.frame.origin.x != 0) {
        
        [UIView animateWithDuration:.3 animations:^{
            
            _mainView.frame = self.view.bounds;
        }];
    }
    
    
    // 定位偏移最终距离
    CGFloat target = 0;
    
    if (_mainView.frame.origin.x > (kScreenW / 2)) {
        // 左移大于屏幕一半时
        target = kRightTarget;
    } else if (CGRectGetMaxX(_mainView.frame) < (kScreenW / 2)) {
        // 右移小于屏幕一半时
        target = kLeftTarget;
    }
    
    [UIView animateWithDuration:.3 animations:^{
        
        if (target) {
            // 在需要定位左边或者右边
            // 获取 x 轴 偏移量 (偏移最终距离 － x)
            CGFloat offsetX = target - _mainView.frame.origin.x;
            NSLog(@"%lf", offsetX);
            //
            _mainView.frame = [self getCurrentFrameWithOffsetX:offsetX];
            
        } else {
            // 还原
            _mainView.frame = self.view.bounds;
        }
    }];
    
    _isTarget = NO;
}





@end

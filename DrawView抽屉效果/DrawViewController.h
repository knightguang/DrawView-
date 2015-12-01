//
//  DrawViewController.h
//  DrawView抽屉效果
//
//  Created by 光 on 15/12/1.
//  Copyright © 2015年 光. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kScreenW  [UIScreen mainScreen].bounds.size.width
#define kScreenH  [UIScreen mainScreen].bounds.size.height

#define kMaxY 60

#define kRightTarget 230;  // 定位点
#define kLeftTarget  -230;

@interface DrawViewController : UIViewController

@property (nonatomic, weak, readonly) UIView *mainView;
@property (nonatomic, weak, readonly) UIView *leftView;
@property (nonatomic, weak, readonly) UIView *rightView;

@end

//
//  ViewController.m
//  SuperGuessFigure
//
//  Created by  江苏 on 16/4/5.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "ViewController.h"
#import "Questions.h"
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *iconButton;
@property(strong,nonatomic)UIButton* button;
@end

@implementation ViewController
-(UIButton *)button{
    if (_button==nil) {
        _button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _button.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
        _button.alpha=0.0;
        [_button addTarget:self action:@selector(Enlarge:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button];
    }
    return _button;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",[Questions questions]);
}
/**
 * 改变图片大小
 */
- (IBAction)Enlarge:(UIButton *)sender {
    //调用button的setter方法
    if(self.button.alpha==0.0){
    [self button];
    [self.view bringSubviewToFront:self.iconButton];
    //放大动画
    [UIView animateWithDuration:1.0f animations:^{
        self.button.alpha=1.0;
        self.iconButton.frame=CGRectMake(0, (self.view.bounds.size.height-self.view.bounds.size.width)/2, self.view.bounds.size.width, self.view.bounds.size.width);
    }];
    }else{
        //缩小动画
        [UIView animateWithDuration:1.0f animations:^{
            self.button.alpha=0.0;
            self.iconButton.frame=CGRectMake(84, 122, 152, 144);
        }];
    }
}
@end

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
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UIButton *iconButton;
@property (strong, nonatomic) IBOutlet UIView *answerView;
@property (strong, nonatomic) IBOutlet UIView *chooseView;
@property(strong,nonatomic)NSArray* question;
@property(strong,nonatomic)UIButton* button;
/**
 *  顶部索引标识
 */
@property(nonatomic)int index;
@end

@implementation ViewController
-(NSArray *)question{
    if (_question==nil) {
        _question=[Questions questions];
    }
    return _question;
}
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
    Questions* question=self.question[self.index];
    self.tipLabel.text=question.title;
    [self.iconButton setImage:[UIImage imageNamed:question.icon] forState:UIControlStateNormal];
}
/**
 * 改变图片大小
 */
- (IBAction)Enlarge:(UIButton *)sender {
    if(self.button.alpha==0.0){
    //调用button的setter方法
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
- (IBAction)nextQuestion:(UIButton *)sender {
    self.index++;
    self.numLabel.text=[NSString stringWithFormat:@"%d/%lu",self.index+1,(unsigned long)self.question.count];
    Questions* question=self.question[self.index];
    self.tipLabel.text=question.title;
    [self.iconButton setImage:[UIImage imageNamed:question.icon] forState:UIControlStateNormal];
    /**
     *  防止数组越界
     */
    sender.enabled=(self.index<self.question.count-1);
#define ButtonW 35
#define ButtonH 35
#define Marign 10
#define col 7
#define row 3
    for (UIView *view in self.answerView.subviews) {
        [view removeFromSuperview];
    }
    int count=(int)question.answer.length;
    CGFloat answerButtonX=(self.answerView.bounds.size.width-count*ButtonW-(count-1)*Marign)*0.5;
    for (int i=0; i<count; i++) {
        CGFloat x=answerButtonX+i*(ButtonW+Marign);
        UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(x, 0, ButtonW, ButtonH)];
        btn.backgroundColor=[UIColor whiteColor];
        [self.answerView addSubview:btn];
    }
    for (UIView* view in self.chooseView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat chooseButtonX=(self.chooseView.bounds.size.width-col*ButtonW-(col-1)*Marign)*0.5;
    for (int i=0; i<question.options.count; i++) {
        CGFloat x=chooseButtonX+i%col*(ButtonW+Marign);
        CGFloat y=i%row*(ButtonH+Marign);
        UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(x, y, ButtonW, ButtonH)];
        btn.backgroundColor=[UIColor grayColor];
        [btn setTitle:question.options[i] forState:UIControlStateNormal];
        [self.chooseView addSubview:btn];
    }
}
@end

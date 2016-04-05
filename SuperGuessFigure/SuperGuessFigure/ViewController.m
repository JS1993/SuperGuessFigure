//
//  ViewController.m
//  SuperGuessFigure
//
//  Created by  江苏 on 16/4/5.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "ViewController.h"
#import "Questions.h"

#define ButtonW 35
#define ButtonH 35
#define Marign 10
#define col 7
#define row 3

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UIButton *iconButton;
@property (strong, nonatomic) IBOutlet UIView *answerView;
@property (strong, nonatomic) IBOutlet UIView *chooseView;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
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
    self.index=-1;
    [self nextQuestion:self.nextButton];
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
#pragma mark-下一题

- (IBAction)nextQuestion:(UIButton *)sender {
    self.index++;
    //通关校验
    if(self.index==self.question.count) return;
    Questions* question=self.question[self.index];
    //设置基本信息
    [self setUpBasicInfo:question];
    /**防止数组越界*/
    sender.enabled=(self.index<self.question.count-1);
    [self setAnswerButton:question];
    [self setChooseButton:question];
}
/**设置基本信息*/
-(void)setUpBasicInfo:(Questions*)question
{
    self.numLabel.text=[NSString stringWithFormat:@"%d/%lu",self.index+1,(unsigned long)self.question.count];
    self.tipLabel.text=question.title;
    [self.iconButton setImage:[UIImage imageNamed:question.icon] forState:UIControlStateNormal];
}
/**创建答案区按钮*/
-(void)setAnswerButton:(Questions*)question{
    int count=(int)question.answer.length;
    for (UIView* view in self.answerView.subviews) {
            [view removeFromSuperview];
    }
    CGFloat answerButtonX=(self.answerView.bounds.size.width-count*ButtonW-(count-1)*Marign)*0.5;
    for (int i=0; i<count; i++) {
        CGFloat x=answerButtonX+i*(ButtonW+Marign);
        UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(x, 0, ButtonW, ButtonH)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(answerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.answerView addSubview:btn];
    }
}
/**创建备选区按钮*/
-(void)setChooseButton:(Questions*)question{
    if (self.chooseView.subviews.count!=question.options.count) {
        for (UIView* view in self.chooseView.subviews) {
            [view removeFromSuperview];
        }
        CGFloat chooseButtonX=(self.chooseView.bounds.size.width-col*ButtonW-(col-1)*Marign)*0.5;
        for (int i=0; i<question.options.count; i++) {
            CGFloat x=chooseButtonX+i%col*(ButtonW+Marign);
            CGFloat y=i%row*(ButtonH+Marign);
            UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(x, y, ButtonW, ButtonH)];
            [btn setTitle:question.options[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
            btn.tag=i;
            [btn addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.chooseView addSubview:btn];
        }
        //如果按钮已经存在，只需要设置按钮的标题即可
    }else{
        int i=0;
        for (UIButton* btn in self.chooseView.subviews) {
            [btn setTitle:question.options[i++] forState:UIControlStateNormal];
        }
    }
}
#pragma mark-候选按钮的监听方法
-(void)chooseButtonClick:(UIButton*)button{
    //如果答案区按钮已满，跳出
    if ([self isFull]) return;
    //1.在答案区找到一个文字为空的按钮
    UIButton* btn=[self findButton];
    //2.将button的标题设置给答案区的按钮
    [btn setTitle:button.currentTitle forState:UIControlStateNormal];
    //3.将button影藏
    button.hidden=YES;
    //4.判断胜负
    [self judgement];
}
/**判断答案区是否已满*/
-(BOOL)isFull{
    BOOL isFull=YES;
    for (UIButton* btn in self.answerView.subviews) {
        if (btn.currentTitle.length==0) {
            isFull=NO;
            break;
        }
    }
    return isFull;
}
/**判断胜负*/
-(void)judgement{
    //如果四个按钮都有文字，才需要判断结果
    BOOL isFull=[self isFull];
    if (isFull) {
        NSMutableString* str=[NSMutableString string];
        for (UIButton* btn in self.answerView.subviews) {
            [str appendString:btn.currentTitle];
        }
        Questions* question=self.question[self.index];
        if ([str isEqualToString:question.answer]) {
            //当成功后延迟0.5s执行点击下一个问题方法,并设置所有隐藏按钮为可见
            [self performSelector:@selector(nextQuestion:) withObject:self.nextButton afterDelay:0.5];
            [self performSelector:@selector(changeChooseButtonHidden) withObject:nil afterDelay:0.5];
            [self setAnswerButtonColor:[UIColor blueColor]];
        }else{
            [self setAnswerButtonColor:[UIColor redColor]];
        }
    }
}
/**恢复选择区按钮的不影藏状态*/
-(void)changeChooseButtonHidden{
    for (UIButton* btn in self.chooseView.subviews) {
        btn.hidden=NO;
    }
}
/**设置答案区按钮颜色*/
-(void)setAnswerButtonColor:(UIColor*)color{
    for (UIButton* btn in self.answerView.subviews) {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
}
/**找到答案区为空的按钮*/
-(UIButton*)findButton{
    for (UIButton* btn in self.answerView.subviews) {
        if (btn.currentTitle.length==0) {
            return btn;
        }
    }
    return nil;
}
#pragma mark-答案区按钮的点击方法
-(void)answerButtonClick:(UIButton*)button{
    //1.如果按钮没有字，直接返回
    if (button.currentTitle.length==0) return ;
    //2.如果按钮有字，清除文字，在选择区显示
    UIButton* btn=[self optionButtonWithTitle:button.currentTitle];
    //3.显示对应按钮
    btn.hidden=NO;
    //清除按钮文字
    [button setTitle:@"" forState:UIControlStateNormal];
}
-(UIButton*)optionButtonWithTitle:(NSString*)title{
    for (UIButton* btn in self.chooseView.subviews) {
        if ([title isEqualToString:btn.currentTitle]&&btn.hidden) {
            return btn;
        }
    }
    return nil;
}
@end

//
//  Questions.m
//  SuperGuessFigure
//
//  Created by  江苏 on 16/4/5.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "Questions.h"

@implementation Questions
-(instancetype)initWithDict:(NSDictionary*)dict{
    self=[super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)questionWithDict:(NSDictionary*)dict{
    return [[self alloc]initWithDict:dict];
}
+(NSArray*)questions{
    NSArray* arr=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"questions" ofType:@"plist"]];
    NSMutableArray* arrayM=[NSMutableArray array];
    for (NSDictionary* dict in arr) {
        [arrayM addObject:[self questionWithDict:dict]];
    }
    return arrayM;
}
//重写description方法
-(NSString *)description{
    return [NSString stringWithFormat:@"answer:%@ icon:%@ title:%@ options:%@",self.answer,self.icon,self.title,self.options];
}
@end

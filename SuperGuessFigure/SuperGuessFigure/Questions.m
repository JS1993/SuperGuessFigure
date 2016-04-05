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
        [self randomOptions];
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
//让options乱序
-(void)randomOptions
{
    self.options=[self.options sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        int seed=arc4random_uniform(2);
        if (seed) {
            return [obj1 compare:obj2];
        }else{
            return [obj2 compare:obj1];
        }
     }];
}
@end

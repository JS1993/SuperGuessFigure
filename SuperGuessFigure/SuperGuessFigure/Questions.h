//
//  Questions.h
//  SuperGuessFigure
//
//  Created by  江苏 on 16/4/5.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Questions : NSObject
@property(copy,nonatomic)NSString* answer;
@property(copy,nonatomic)NSString* title;
@property(copy,nonatomic)NSString* icon;
@property(strong,nonatomic)NSArray* options;
-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)questionWithDict:(NSDictionary*)dict;
+(NSArray*)questions;
@end

//
//  PeopleModel.m
//  contactCall
//
//  Created by 维世投资 on 16/5/6.
//  Copyright © 2016年 张彦青. All rights reserved.
//

#import "PeopleModel.h"

@implementation PeopleModel

+(id)instanceWithName:(NSString *)name andLocalID:(NSNumber *)localID andPhoneArray:(NSMutableArray *)phoneArray{
    return [[PeopleModel alloc]initwithName:name andLocalID:localID andPhoneArray:phoneArray];
}

-(id)initwithName:(NSString *)name andLocalID:(NSNumber *)localID andPhoneArray:(NSMutableArray *)phoneArray{
    if ([self init]) {
        self.localID = localID;
        self.name = name;
        self.phoneArray = phoneArray;
    }
    return self;
}

+ (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);//带音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);//不带音标
    return [pinyin uppercaseString];

}

@end

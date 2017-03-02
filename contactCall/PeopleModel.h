//
//  PeopleModel.h
//  contactCall
//
//  Created by 维世投资 on 16/5/6.
//  Copyright © 2016年 张彦青. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromHexstring(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define KDailSearchFunction @"22233344455566677778889999"
#import "SearchCoreManager.h"

@interface PeopleModel : NSObject

@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSNumber* localID;
@property(nonatomic,strong)NSMutableArray* phoneArray;

+(id)instanceWithName:(NSString*)name andLocalID:(NSNumber*)localID andPhoneArray:(NSMutableArray*)phoneArray;

@end

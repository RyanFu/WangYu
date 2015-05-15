//
//  WYLocationServiceUtil.h
//  WangYu
//
//  Created by KID on 15/5/14.
//  Copyright (c) 2015年 KID. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;
typedef void(^LocationBlock)(NSString *errorString);
typedef void(^LocationSucessBlock)(CLLocation *location);

@interface WYLocationServiceUtil : NSObject

+(WYLocationServiceUtil *) shareInstance;

//简单判断定位服务是否开启
+(BOOL) isLocationServiceOpen;

//获取用户地址
-(void) getUserCurrentLocation:(LocationBlock) block location:(LocationSucessBlock) locationSucess;

@end
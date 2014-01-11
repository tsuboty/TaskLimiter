//
//  testModel.h
//  TaskLimiter
//
//  Created by 坪田 亮 on 2014/01/02.
//  Copyright (c) 2014年 ryo tsubota. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface testModel : NSObject

@property (nonatomic, retain) NSString * name;      //タスク名
@property (nonatomic, retain) NSDate * date;        //開始日
@property (nonatomic, retain) NSDate * timer;       //
@property (nonatomic, retain) NSDate * lastTimer;   //残り時間



@property (nonatomic, retain) NSNumber * repeat;    //繰り返し
@property (nonatomic, retain) NSString * context;   //コンテキスト
@property (nonatomic, retain) NSString * project;   //プロジェクト


@property (nonatomic, retain) NSString * status;    //

@end

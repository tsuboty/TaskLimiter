//
//  Task.h
//  TaskLimiter
//
//  Created by 坪田 亮 on 2014/01/01.
//  Copyright (c) 2014年 ryo tsubota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * name;      //タスク名
@property (nonatomic, retain) NSDate * date;        //

@property (nonatomic, retain) NSString * context;   //
@property (nonatomic, retain) NSNumber * repeat;    //
@property (nonatomic, retain) NSString * project;   //
@property (nonatomic, retain) NSDate * timer;       //
@property (nonatomic, retain) NSDate * lastTimer;   //
@property (nonatomic, retain) NSString * status;    //

@end

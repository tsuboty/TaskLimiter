//
//  Task.h
//  TaskLimiter
//
//  Created by 坪田 亮 on 2014/01/17.
//  Copyright (c) 2014年 ryo tsubota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * context;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * lastTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * project;
@property (nonatomic, retain) NSNumber * repeat;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDate * timer;

@end

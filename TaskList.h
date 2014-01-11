//
//  TaskList.h
//  TaskLimiter
//
//  Created by 坪田 亮 on 2014/01/01.
//  Copyright (c) 2014年 ryo tsubota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Task.h"

@class Task;

@interface TaskList : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Task *task;

@end

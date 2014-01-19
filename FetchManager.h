//
//  FetchManager.h
//  TaskLimiter
//
//  Created by 坪田 亮 on 2014/01/18.
//  Copyright (c) 2014年 ryo tsubota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface FetchManager : NSObject

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

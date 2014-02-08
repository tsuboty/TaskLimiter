//
//  DataManager.h
//  TaskLimiter
//
//  Created by 坪田 亮 on 2014/01/18.
//  Copyright (c) 2014年 ryo tsubota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject


//use coredata
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property(readonly, strong, nonatomic) NSString *dbName;


//- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (id)sharedData;
- (NSArray *)recordsWithEntityName:(NSString *)entityName;

@end

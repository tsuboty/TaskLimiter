//
//  FirstViewController.h
//  TaskLimiter
//
//  Created by 坪田 亮 on 2013/12/30.
//  Copyright (c) 2013年 ryo tsubota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DataManager.h"



//testModel *tm;
//NSMutableArray *tasks;



@interface FirstViewController : UIViewController

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSEntityDescription *entity;




- (IBAction)setEstimatedTimePicker:(id)sender forEvent:(UIEvent *)event;


@end

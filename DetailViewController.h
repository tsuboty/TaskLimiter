//
//  DetailViewController.h
//  TaskLimiter
//
//  Created by 坪田 亮 on 2014/01/23.
//  Copyright (c) 2014年 ryo tsubota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSEntityDescription *entity;


@property (nonatomic) UIViewController *preContloller;

@property (weak, nonatomic) IBOutlet UITextField *taskname;


//見積時間
@property (weak, nonatomic) IBOutlet UIButton *estimatedTimeLabel;
- (IBAction)estimatedTimeButton:(id)sender;

//実施日
@property (weak, nonatomic) IBOutlet UIButton *dueDateLabel;
- (IBAction)dueDateButton:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *teTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *teTimeButton;
@property NSIndexPath *indexPath;

@property NSDate *dueDate;//実行日
@property NSInteger estimatedTime; //見積時間
@property NSInteger teTime;//経過時間



@end

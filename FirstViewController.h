//
//  FirstViewController.h
//  TaskLimiter
//
//  Created by 坪田 亮 on 2013/12/30.
//  Copyright (c) 2013年 ryo tsubota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "testModel.h"

testModel *tm;
NSMutableArray *tasks;

@interface FirstViewController : UIViewController

- (BOOL)saveTasks:(NSMutableArray *)tasks;

@end

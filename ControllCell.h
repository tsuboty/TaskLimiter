//
//  ControllCell.h
//  TaskLimiter
//
//  Created by 坪田 亮 on 2014/01/19.
//  Copyright (c) 2014年 ryo tsubota. All rights reserved.
//

#import <UIKit/UIKit.h>

NSDateComponents *comp;
NSCalendar *gcal;
NSInteger flg;

@interface ControllCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellname;
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimatedTime;
@property (weak, nonatomic) IBOutlet UILabel *teTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;


@property (retain) NSDate *startTime;
@property (retain) NSDate *endTime;
@property (retain) NSDate *dueDate;

@property (retain) NSString *category;
@property (retain) NSString *repeat;
@property BOOL flag;
@property int *layer;
@property int teTime;
@property NSTimeInterval playTime;
@property NSIndexPath *indexPath;


@property BOOL onoff;

- (IBAction)playButton:(id)sender;
- (IBAction)editButton:(id)sender;


@end

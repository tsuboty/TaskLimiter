//
//  ControllCell.m
//  TaskLimiter
//
//  Created by 坪田 亮 on 2014/01/19.
//  Copyright (c) 2014年 ryo tsubota. All rights reserved.
//

#import "ControllCell.h"

@implementation ControllCell

@synthesize cellname;
@synthesize onoff;

@synthesize teTime;
@synthesize startTime;
@synthesize endTime;
@synthesize dueDate;
@synthesize category;
@synthesize repeat;
@synthesize flag;
@synthesize layer;
@synthesize indexPath;

NSTimeInterval playtime;
int min;
int sec;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        onoff = NO;
    }
     [self.playButton setImage:[UIImage imageNamed:@"stoptaskwithCircle.png"] forState:UIControlStateNormal];
 

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (IBAction)playButton:(id)sender {

    // タイマーoffの時、タイマースタート
    NSTimer *tm;
    if(!onoff){
        onoff = YES;
        [self.playButton setImage:[UIImage imageNamed:@"stoptaskwithCircle.png"] forState:UIControlStateNormal];
        tm = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                       target:self
                                                     selector:@selector(hoge:)
                                                     userInfo:nil
                                                      repeats:YES
                       ];
        
        startTime = [NSDate date];
        
        
    }
    else{
        onoff = NO;
        teTime += (int)playtime ;
        
        self.teTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",teTime/60,teTime%60];
        [self.playButton setImage:[UIImage imageNamed:@"playtaskwithCircle.png"] forState:UIControlStateNormal];
        [tm invalidate];
    }

 
}

- (IBAction)editButton:(id)sender {
}

// 呼ばれるhogeメソッド
-(void)hoge:(NSTimer*)timer{
    // ここに何かの処理を記述する
    // （引数の timer には呼び出し元のNSTimerオブジェクトが引き渡されてきます）

    endTime = [NSDate date];
    playtime = [endTime timeIntervalSinceDate:startTime];

    min = playtime/60;
    sec = (int)playtime%60;
    self.playTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    
    
    if(!onoff){
        [timer invalidate];
        self.playTimeLabel.text = @"00:00";
    }

 
 }




@end

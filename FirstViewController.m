//
//  FirstViewController.m
//  TaskLimiter
//
//  Created by 坪田 亮 on 2013/12/30.
//  Copyright (c) 2013年 ryo tsubota. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UILabel *strHour;
@property (weak, nonatomic) IBOutlet UILabel *strMin;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;



- (IBAction)dataPicker:(UIDatePicker *)sender;


@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
    
//    [self.dataPicker init];
    self.dataPicker.datePickerMode = UIDatePickerModeCountDownTimer;
    
/*    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:2010];
    [comps setMonth:1];
    [comps setDay:2];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:5];
    NSDate *date = [calendar dateFromComponents:comps];
    
    
    self.dataPicker.date = date;
*/    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dataPicker:(UIDatePicker *)sender {
//Picker 変更時に呼び出される。
    
    //Picker の値
    NSDate *date = self.dataPicker.date;
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    
    df.dateFormat = @"H";
    self.strHour.text = [df stringFromDate:date];
    
    df.dateFormat = @"m";
    self.strMin.text = [df stringFromDate:date];
    
    NSLog(@"%@",[df stringFromDate:date]);
    
    
    //引数にPickerでとった誕生日を入れる。戻り値は現在との差分を計算したNSDateComponets
 //   NSDateComponents *comp = [self calcCalendar:birthdayComp];
    
    //outletに表示
 //   self.born.text = [NSString stringWithFormat:@"%d",comp.day];
    
    
}
@end

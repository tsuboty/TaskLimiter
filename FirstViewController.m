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
@property (weak, nonatomic) IBOutlet UITextField *inputTask;



- (IBAction)inputTask:(id)sender;
- (IBAction)dataPicker:(UIDatePicker *)sender;
- (IBAction)inputButton:(id)sender;


@end

@implementation FirstViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.dataPicker.datePickerMode = UIDatePickerModeCountDownTimer;

//    self.dataPicker.opaque = NO;
//    self.dataPicker.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:1.0 alpha:0.1f];
    
    self.inputTask.delegate = self;
    tasks = [NSMutableArray array];
    
    
    //CoreData初期設定
    
    // NSManagedObjectModel

    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.inputTask resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//textfieldでDone時
- (IBAction)inputTask:(id)sender {

    
}



//Picker 変更時に呼び出される。
- (IBAction)dataPicker:(UIDatePicker *)sender {
    
    //Pickeで取得したdate
    NSDate *date = self.dataPicker.date;
//    NSTimeInterval  since = [self.dataPicker.date timeIntervalSinceNow];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"H";
    self.strHour.text = [df stringFromDate:date];
    df.dateFormat = @"m";
    self.strMin.text = [df stringFromDate:date];

    
}


//inputボタンを押したとき
- (IBAction)inputButton:(id)sender {
    //1つのタスクに１つのインスタンスを作成する。
    tm = [[testModel alloc]init];
    
    //モデルに情報を入力
    tm.name = self.inputTask.text;
    tm.date = self.dataPicker.date;
    
    //tasks配列に格納
    [tasks addObject:tm];
    
/*　　 for(int i=0;i<tasks.count;i++){
        testModel *t;
        t = [tasks objectAtIndex:i];
        NSLog(@"配列%dは%@",i,t.name);
    }
*/
    [self saveTasks:tasks];
    

    
    //タスクフィール ドを空にする。
    self.inputTask.text = @"";
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
	[inputDateFormatter setDateFormat:@"HH:mm"];
	NSString *intputDateStr = @"00:00";
	NSDate *inputDate = [inputDateFormatter dateFromString:intputDateStr];
    
    
    self.dataPicker.date = inputDate;
    self.strHour.text = @"0";
    self.strMin.text = @"0";
    
    
    
    NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
    
    //キーと値をセットにする。
    [myDefaults setInteger:tm.name forKey:@"name"];
    [myDefaults setInteger:tm.date forKey:@"date"];
    
    //同期処理
    [myDefaults synchronize];
    
    
    
}

//tasksをNSData型にしてuserdefaultで保存メソッド
- (BOOL)saveTasks:(NSMutableArray *)tasks{
    //UserDefaultsを利用してデータを記録する。

    

    
    
    return TRUE;
}



@end

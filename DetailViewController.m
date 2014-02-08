//
//  DetailViewController.m
//  TaskLimiter
//
//  Created by 坪田 亮 on 2014/01/23.
//  Copyright (c) 2014年 ryo tsubota. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImage+ImageEffects.h"
#import "TaskListViewController.h"



@interface DetailViewController ()

@property (nonatomic) UIImage *image;
@property int index;
@property NSFetchRequest *request;
@property NSArray *records;
@property BOOL timePickerSwitch;

- (IBAction)delete:(id)sender;

//DatePickerのプロパティなど
- (IBAction)editDatePicker:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *editDatePickerValue;
@property NSString *datePickerMode; //Time(時間) or Date(日付)
//toolBarのプロパティ
@property (weak, nonatomic) IBOutlet UIToolbar *editPickerToolBar;


@end



@implementation DetailViewController

@synthesize preContloller;
@synthesize indexPath;
@synthesize dueDate;
@synthesize estimatedTime;
@synthesize teTime;
@synthesize mo;

//DB格納用に秒で変数にいれる。
int estimatedTimeSec;
int teTimeSec;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//CoreData設定
    DataManager *dm = [DataManager sharedData];
    _managedObjectContext = dm.managedObjectContext;
    NSError *error = nil;
    _request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    _records = [_managedObjectContext executeFetchRequest:_request error:&error];
    
    //DatePickerを隠す
    self.editDatePickerValue.alpha = 0.0f;
    self.editPickerToolBar.alpha = 0.0f;
    _timePickerSwitch = NO;
    NSLog(@"%@",@"call");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//モーダルウィンドウを閉じる(完了ボタン)　編集したものをDBへ格納
- (IBAction)returnButton:(id)sender {
   //表示しているプロパティをDBへ格納(ManagedObject は受け取ったもの。)
    [mo setValue:self.taskname.text forKey:@"name"];
    [mo setValue:dueDate forKey:@"dueDate"];
    [mo setValue:[NSNumber numberWithInt:estimatedTime] forKey:@"estimatedTime"];
    [mo setValue:[NSNumber numberWithInt:teTime] forKey:@"teTime"];
    
    NSError *error;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//削除ボタンが押された時
- (IBAction)delete:(id)sender {
    //DBデータの削除
    NSError *error = nil;
    _records = [_managedObjectContext executeFetchRequest:_request error:&error];
    [_managedObjectContext deleteObject:[_records objectAtIndex:indexPath.row]];
    
    if (![_managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
        
    }
    // 削除時のAnimation recordsを更新しないとエラーになる。
    _records = [_managedObjectContext executeFetchRequest:_request error:&error];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

- (IBAction)editDataPicker:(id)sender {
}
//タスク修正テキストフィールド
- (IBAction)textFieldDidEndOnExit:(id)sender {
    
    
}

//実行日修正ボタン
- (IBAction)dueDateButton:(id)sender {
    self.editDatePickerValue.datePickerMode = UIDatePickerModeDate;
    self.editDatePickerValue.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    _datePickerMode = @"date";//Done押下時に使う
    self.editDatePickerValue.date = dueDate;
    if (!_timePickerSwitch) {
        [self showModal:self.editDatePickerValue];
        [self showModal:self.editPickerToolBar];
    }
    
    
}

//見積時間修正ボタン、経過時間ボタン
- (IBAction)estimatedTimeButton:(id)sender {
    self.editDatePickerValue.datePickerMode = UIDatePickerModeCountDownTimer;
    self.editDatePickerValue.minuteInterval = 5;
    
    //ios7のバグか １回目の入力を実施するため,データ初期値を入力する。
    NSString *firstDateString = @"00:00";
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"HH:mm"];
    NSDate *firstDate = [dateFormater dateFromString:firstDateString];
    [self.editDatePickerValue setDate:firstDate animated:YES];
    
    
    UIButton *bt = sender;
    //tag:0 見積時間ボタン　tag:1 経過時間
    if (bt.tag == 0) {
        _datePickerMode = @"time";//見積時間　Done押下時に使う
        self.editDatePickerValue.date = [self stringToDate:[self secondToHhMmSsString:estimatedTime]];
    }else if(bt.tag == 1){
        _datePickerMode = @"tetime";//経過時間
        self.editDatePickerValue.date = [self stringToDate:[self secondToHhMmSsString:teTime]];
    }
    
    //表示されていない場合、アニメーションで表示
    if (!_timePickerSwitch) {
        [self showModal:self.editDatePickerValue];
        [self showModal:self.editPickerToolBar];
    }
    
}

//datePickerが変更された時に呼び出される
- (IBAction)editDatePicker:(id)sender {
    //実行日ボタンの編集
    if ([_datePickerMode isEqualToString:@"date"]) {
        NSDate *date = self.editDatePickerValue.date;
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy年MM月dd日";
        //ボタンタイトル修正
        [self.dueDateLabel setTitle:[df stringFromDate:date] forState:UIControlStateNormal];
        
        //DB登録用変数
        dueDate = date;
    }
    //見積時間と経過時間の編集の場合
    else {
        NSDate *date = self.editDatePickerValue.date;
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"H";
        NSString *strHour = [df stringFromDate:date];
        df.dateFormat = @"m";
        NSString *strMin = [df stringFromDate:date];
        //見積時間ボタンの場合
        if ([_datePickerMode isEqualToString:@"time"]) {
            //DB登録用の変数（秒）
            estimatedTime = [strHour intValue]*3600 + [strMin intValue]*60;
            
            //ボタンタイトル修正
            int h = estimatedTime/3600;
            int m = (estimatedTime - h*3600)/60;
            NSString *str = [NSString stringWithFormat:@"%02d:%02d",h,m];
            [self.estimatedTimeLabel setTitle:str forState:UIControlStateNormal];
            
        }
        //経過時間ボタンの場合
        else if([_datePickerMode isEqualToString:@"tetime"]){
            //DB登録用の変数（秒）
            teTime = [strHour intValue]*3600 + [strMin intValue]*60;
            //ボタンタイトル修正
            int h = teTime/3600;
            int m = (teTime - h*3600)/60;
            NSString *str = [NSString stringWithFormat:@"%02d:%02d",h,m];
            [self.teTimeLabel setTitle:str forState:UIControlStateNormal];
            
        }
    }
}

//ToolBarでDoneボタンを押した動作
- (IBAction)toolBarDone:(id)sender {
    if (_timePickerSwitch) {
        [self hideModal:self.editDatePickerValue];
        [self hideModal:self.editPickerToolBar];
    }
}

//UIiewアニメーションで表示
- (void) hideModal:(UIView*) modalView {
    _timePickerSwitch = NO;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //アニメーションの時間
    [UIView setAnimationDuration:0.5f];
    //アニメーション後の状態
    [modalView setAlpha:0.0f];
    [UIView commitAnimations];
}

- (void) showModal:(UIView*) modalView {
    _timePickerSwitch = YES;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //アニメーションの時間
    [UIView setAnimationDuration:0.5f];
    //アニメーション後の状態
    [modalView setAlpha:1.0f];
    [UIView commitAnimations];
}

-(NSString *)secondToHhMmSsString:(int)second{
    int h = second/3600;
    int m = (second - h*3600)/60;
    int s = second % 60;
    NSString *HhMmSsString = [NSString stringWithFormat:@"%02d:%02d:%02d",h,m,s];
    return HhMmSsString;
}

-(NSDate *)stringToDate:(NSString *)str{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"hh:mm:ss"];
    NSDate *formatterDate = [inputFormatter dateFromString:str];
    return formatterDate;
}

@end

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
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property BOOL timePickerSwitch;
@property NSString *pickerMode;
@property (weak, nonatomic) IBOutlet UIButton *setEstimatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
@property NSDate *dueDate;

//DataPicke上のツールバープロパティ
@property (weak, nonatomic) IBOutlet UIToolbar *pickerToolBar;
- (IBAction)setTimeBarButton:(id)sender;

//見積もり時間ボタンのプロパティ
@property (weak, nonatomic) IBOutlet UIButton *estimatedButtonLabel;
- (IBAction)setEstimatedTimeButton:(id)sender forEvent:(UIEvent *)event;

//実行日ボタンのプロパティ
@property (weak, nonatomic) IBOutlet UIButton *dueDateButtonLabel;
- (IBAction)dueDateButton:(id)sender forEvent:(UIEvent *)event;

- (IBAction)inputTask:(id)sender;
- (IBAction)dataPicker:(UIDatePicker *)sender;
- (IBAction)inputButton:(id)sender;


@end

@implementation FirstViewController

@synthesize entity;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //DB設定
    DataManager *dm = [DataManager sharedData];
    self.managedObjectContext = dm.managedObjectContext;
    
    //見積時間ボタンの表示設定(タイトル左寄せ)
    self.estimatedButtonLabel.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    
    //実行日ボタンの表示設定(タイトル左寄せ)
    self.dueDateButtonLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    //timePickerの表示するかしないか設定
    _timePickerSwitch = NO;
    self.dataPicker.alpha = 0.0f; //datapickerは初期表示透明
    [_dataPicker addTarget:self action:@selector(dataPicker) forControlEvents:UIControlEventTouchDown];
    
    //toolBarの初期設定
    self.pickerToolBar.alpha = 0.0f; //toolbarは初期表示透明

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//タスク名入力フィールドでテキスト Done 押下時 キーボードを消す
- (IBAction)textEditEnd:(id)sender {
    [self.inputTask resignFirstResponder];
}


//見積時間 入力ボタンを押した時の動作
- (IBAction)setEstimatedTimeButton:(id)sender forEvent:(UIEvent *)event {
    _pickerMode = @"time";      //Pickeをタイマーで表示
    self.dataPicker.datePickerMode = UIDatePickerModeCountDownTimer;
    _dataPicker.minuteInterval = 5;
    
    //ios7のバグか １回目の入力を実施するため,データ初期値を入力する。
    NSString *firstDateString = @"00:00";
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"HH:mm"];
    NSDate *firstDate = [dateFormater dateFromString:firstDateString];
    [self.dataPicker setDate:firstDate animated:YES];
    
    //ピッカービューが表示されていない時→表示する
    if (!_timePickerSwitch) {
        _timePickerSwitch = YES;
        self.dataPicker.backgroundColor = [UIColor whiteColor];
        [self showModal:self.dataPicker.viewForBaselineLayout];
        [self showModal:self.pickerToolBar.viewForBaselineLayout];
    }

}

//実行日 入力ボタンを押した時のメソッド
- (IBAction)dueDateButton:(id)sender forEvent:(UIEvent *)event {
    self.dataPicker.datePickerMode = UIDatePickerModeDate;
    self.dataPicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    _pickerMode = @"date";
    
    if (!_timePickerSwitch) {
        _timePickerSwitch = YES;
        self.dataPicker.backgroundColor = [UIColor whiteColor];
        [self showModal:self.dataPicker.viewForBaselineLayout];
        [self showModal:self.pickerToolBar.viewForBaselineLayout];
    }
    
}

//Tabbar の　Doneボタンを押した時の動作
- (IBAction)setTimeBarButton:(id)sender {
    
    //見積時間入力時のDone
    if ([_pickerMode  isEqual: @"time"]) {
        NSString *estimatedTimeName = [NSString stringWithFormat:@"%@:%@",self.strHour.text,self.strMin.text];
        
        [self.estimatedButtonLabel setTitle:estimatedTimeName forState:UIControlStateNormal];
        
    }
    //実施日付入力のとき
    else if ([_pickerMode  isEqual: @"date"]){
        [self.dueDateButtonLabel setTitle:self.dueDateLabel.text forState:UIControlStateNormal];
    }
    
    
    _timePickerSwitch = NO;
    [self hideModal:self.dataPicker.viewForBaselineLayout];
    [self hideModal:self.pickerToolBar.viewForBaselineLayout];
}

//Picker 変更時に呼び出される。
- (IBAction)dataPicker:(UIDatePicker *)sender {
    
    //Pickeが見積時間を入力する場合
    if ([_pickerMode  isEqual: @"time"]) {
        NSDate *date = self.dataPicker.date;
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"H";
        self.strHour.text = [df stringFromDate:date];
        df.dateFormat = @"m";
        self.strMin.text = [df stringFromDate:date];
    
        if ([self.strHour.text  isEqual: @"1"]) {
            self.hoursLabel.text = @"hour";
        } else {
            self.hoursLabel.text = @"hours";
        }
    }
    //Picerが実行日を入力する場合
    else if ([_pickerMode isEqual:@"date"]){
        NSDate *date = self.dataPicker.date;
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy年MM月dd日";
        self.dueDateLabel.text = [df stringFromDate:date];
        _dueDate = date;
        
    }
    
}


//inputボタンを押したとき
- (IBAction)inputButton:(id)sender {
    if([self.inputTask.text length ]>0){
        //1つのタスクに１つのインスタンスを作成する。
        [self insertNewObject:nil];

        //タスクフィール ドを空にする。
        self.inputTask.text = @"";
        NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
        [inputDateFormatter setDateFormat:@"HH:mm"];
        NSString *intputDateStr = @"00:00";
        NSDate *inputDate = [inputDateFormatter dateFromString:intputDateStr];
        self.dataPicker.date = inputDate;
        self.strHour.text = @"0";
        self.strMin.text = @"0";
        [self.estimatedButtonLabel setTitle:@"" forState:UIControlStateNormal];
        [self.dueDateButtonLabel setTitle:@"" forState:UIControlStateNormal];
        
    }
}



//Inputボタンを押した時にDBへデータを書き込む
- (void)insertNewObject:(id)sender
{
    entity = [[self.fetchedResultsController fetchRequest] entity];
    
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:_managedObjectContext];
    
    //タスク名の保存
    [newManagedObject setValue:self.inputTask.text forKey:@"name"];
    
    //見積もり時間の保存
    int estimatedTime = [self.strHour.text intValue] * 3600 + [self.strMin.text intValue] * 60;
    [newManagedObject setValue:[NSNumber numberWithInt:estimatedTime] forKey:@"estimatedTime"];
    
    //実行予定日の保存
    [newManagedObject setValue:_dueDate forKey:@"dueDate"];
        
    // Save the context.
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}




//UIiewアニメーションで表示
- (void) hideModal:(UIView*) modalView {

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
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //アニメーションの時間
    [UIView setAnimationDuration:0.5f];
    //アニメーション後の状態
    [modalView setAlpha:1.0f];
    [UIView commitAnimations];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    //   aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}



@end

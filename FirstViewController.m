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

@synthesize entity;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    DataManager *dm = [DataManager sharedData];
    self.dataPicker.datePickerMode = UIDatePickerModeCountDownTimer;
    self.managedObjectContext = dm.managedObjectContext;
    _dataPicker.minuteInterval = 5;

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
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"H";
    self.strHour.text = [df stringFromDate:date];
    df.dateFormat = @"m";
    self.strMin.text = [df stringFromDate:date];
}


//inputボタンを押したとき
- (IBAction)inputButton:(id)sender {
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
    
    
    
}

//tasksをNSData型にしてuserdefaultで保存メソッド
- (BOOL)saveTasks:(NSMutableArray *)tasks{
    //UserDefaultsを利用してデータを記録する。
    return TRUE;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
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

- (void)insertNewObject:(id)sender
{
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:_managedObjectContext];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:self.inputTask.text forKey:@"name"];
    [newManagedObject setValue:self.dataPicker.date forKey:@"date"];
    
    
    // Save the context.
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}
@end

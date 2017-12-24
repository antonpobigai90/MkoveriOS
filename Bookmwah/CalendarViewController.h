//
//  FSViewController.h
//  Chinese-Lunar-Calendar
//
//  Created by Wenchao Ding on 01/29/2015.
//  Copyright (c) 2017 Wenchao Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "ScheduleCell.h"

@interface CalendarViewController : UIViewController

@property ScheduleCell *schedule;

@property NSMutableDictionary *dictRespon;
@property NSMutableArray *arrybooking;
@property NSSet *set;
@property NSMutableArray *aryDailyData;

@property (weak, nonatomic) IBOutlet UITableView *scheduleTv;

@end

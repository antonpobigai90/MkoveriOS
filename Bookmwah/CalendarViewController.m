//
//  StoryboardExampleViewController.m
//  Chinese-Lunar-Calendar
//
//  Created by Wenchao Ding on 01/29/2015.
//  Copyright (c) 2014 Wenchao Ding. All rights reserved.
//

#import "CalendarViewController.h"
#import "LunarFormatter.h"
#import "Constant.h"

@interface CalendarViewController()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (weak  , nonatomic) IBOutlet FSCalendar *calendar;
@property (weak  , nonatomic) IBOutlet NSLayoutConstraint *calendarHeightConstraint;

@property (assign, nonatomic) NSInteger      theme;
@property (assign, nonatomic) BOOL           lunar;

@property (strong, nonatomic) NSArray<NSString *> *datesShouldNotBeSelected;
@property (strong, nonatomic) NSArray<NSString *> *datesWithEvent;

@property (strong, nonatomic) NSCalendar *gregorianCalendar;

@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@property (strong, nonatomic) NSDateFormatter *dateFormatter2;
@property (strong, nonatomic) LunarFormatter *lunarFormatter;

- (IBAction)unwind2StoryboardExample:(UIStoryboardSegue *)segue;

@end

@implementation CalendarViewController
@synthesize scheduleTv, schedule, aryDailyData;

#pragma mark - Life Cycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSLocale *chinese = [NSLocale localeWithLocaleIdentifier:@"zh-EN"];
        
        self.dateFormatter1 = [[NSDateFormatter alloc] init];
        self.dateFormatter1.locale = chinese;
        self.dateFormatter1.dateFormat = @"dd-MM-yyyy";
        
        self.dateFormatter2 = [[NSDateFormatter alloc] init];
        self.dateFormatter2.locale = chinese;
        self.dateFormatter2.dateFormat = @"dd-MM-yyyy";
        
        self.calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase;
        
        self.datesShouldNotBeSelected = @[@"2016/08/07",
                                          @"2016/09/07",
                                          @"2016/10/07",
                                          @"2016/11/07",
                                          @"2016/12/07",
                                          @"2016/01/07",
                                          @"2016/02/07"];
        
        self.lunarFormatter = [[LunarFormatter alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([[UIDevice currentDevice].model hasPrefix:@"iPad"]) {
        self.calendarHeightConstraint.constant = 400;
    }
    
    [self.calendar selectDate:[self.dateFormatter1 dateFromString:@"2017/12/19"] scrollToDate:YES];
    
    self.calendar.accessibilityIdentifier = @"calendar";
    
    schedule = [ScheduleCell new];
    
    self.aryDailyData = [NSMutableArray new];
    self.dictRespon = [NSMutableDictionary new];
    self.arrybooking = [NSMutableArray new];
    self.set = [NSSet new];
    
    UIView* footerView = [[UIView alloc] init];
    [scheduleTv setTableFooterView:footerView];
}

-(void)viewWillAppear:(BOOL)animated {
    [self Call_Schedule];
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)Call_Schedule
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSString *pro_id = [NSUD valueForKey:@"pro_id"];
    [dict setValue:pro_id forKey:@"pro_id"];
    
    [WebService call_API:dict andURL:API_SCHEDULE andImage:nil andImageName:nil andFileName:nil OnResultBlock:^(id response, MDDataTypes mdDataType, NSString *status) {
        
        NSString * sts = [response objectForKey:@"status"];
        if ([sts isEqualToString:@"true"])
        {
            NSLog(@"%@",response);
            self.dictRespon = response;
            self.arrybooking = [response valueForKey:@"schedule"];
            
            NSArray *array  = [NSArray arrayWithArray: self.arrybooking];
            _set = [NSSet setWithArray:[array valueForKey:@"book_date"]];
            NSLog( @"set%@",_set);
            
            NSMutableArray *arrayDates = [NSMutableArray arrayWithArray:[self.set allObjects]];
            NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
            NSArray *sorters = [[NSArray alloc] initWithObjects:sorter, nil];
            NSArray *sortedArray = [arrayDates sortedArrayUsingDescriptors:sorters];
            NSMutableArray *sortArray = [[NSMutableArray alloc] init];
            [sortArray addObjectsFromArray:sortedArray];
            NSLog(@"sortArray : %@",sortArray);
            
            self.datesWithEvent = sortArray;
            [self.calendar reloadData];
            
            aryDailyData = [self Set_Row_insection:[self.dateFormatter1 stringFromDate:[NSDate date]]];
            [scheduleTv reloadData];
        }
        else
        {
            _AlertView_WithOut_Delegate(@"Message",[response objectForKey:@"message"], @"OK", nil);
        }
    }];
}

-(NSMutableArray *)Set_Row_insection:(NSString *)date
{
    NSLog(@"%@",_arrybooking);
    
    NSMutableArray *arraySectionRowcount = [NSMutableArray new];
    
    for (int i=0; i<_arrybooking.count; i++)
    {
        NSString *strDate = [[_arrybooking objectAtIndex:i]valueForKey:@"book_date"];
        if ([strDate isEqualToString:date]) {
            [arraySectionRowcount  addObject:[_arrybooking objectAtIndex:i]];
        }
    }
    
    return arraySectionRowcount;
}

#pragma mark - Tableview Delegate Methods
#pragma mark -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryDailyData.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    schedule = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCell" forIndexPath:indexPath];
    
    NSDictionary *dict = [aryDailyData objectAtIndex:indexPath.row];
    
    schedule.image_View.layer.cornerRadius = 25.0;
    schedule.image_View.layer.masksToBounds = YES;
 
    NSString *imgURL = [dict valueForKey:@"u_image"];
    [schedule.image_View setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"small_default_img"]];
    
    schedule.lbl_Name.text = [dict valueForKey:@"s_name"];
    schedule.lbl_Servicetype.text = [dict valueForKey:@"s_cat_name"];
    schedule.lbl_Bookingtime.text = [NSString stringWithFormat:@"%@ ~ %@", [dict valueForKey:@"book_time"], [dict valueForKey:@"book_to_time"]];
    
    return schedule;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - FSCalendarDataSource

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    return [self.gregorianCalendar isDateInToday:date] ? @"今天" : nil;
}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    if (!_lunar) {
        return nil;
    }
    return [self.lunarFormatter stringFromDate:date];
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    if ([self.datesWithEvent containsObject:[self.dateFormatter2 stringFromDate:date]]) {
        return 1;
    }
    return 0;
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter1 dateFromString:@"2016/10/01"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter1 dateFromString:@"2018/05/31"];
}

#pragma mark - FSCalendarDelegate

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    BOOL shouldSelect = ![_datesShouldNotBeSelected containsObject:[self.dateFormatter1 stringFromDate:date]];
    if (!shouldSelect) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"FSCalendar" message:[NSString stringWithFormat:@"FSCalendar delegate forbid %@  to be selected",[self.dateFormatter1 stringFromDate:date]] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        NSLog(@"Should select date %@",[self.dateFormatter1 stringFromDate:date]);
    }
    return shouldSelect;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter1 stringFromDate:date]);
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
    
    [aryDailyData removeAllObjects];
    aryDailyData = [self Set_Row_insection:[self.dateFormatter1 stringFromDate:date]];
    [scheduleTv reloadData];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change to page %@",[self.dateFormatter1 stringFromDate:calendar.currentPage]);
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    _calendarHeightConstraint.constant = CGRectGetHeight(bounds);
    [self.view layoutIfNeeded];
}

- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleOffsetForDate:(NSDate *)date
{
    if ([self calendar:calendar subtitleForDate:date]) {
        return CGPointZero;
    }
    if ([_datesWithEvent containsObject:[self.dateFormatter2 stringFromDate:date]]) {
        return CGPointMake(0, -2);
    }
    return CGPointZero;
}

- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventOffsetForDate:(NSDate *)date
{
    if ([self calendar:calendar subtitleForDate:date]) {
        return CGPointZero;
    }
    if ([_datesWithEvent containsObject:[self.dateFormatter2 stringFromDate:date]]) {
        return CGPointMake(0, -10);
    }
    return CGPointZero;
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventSelectionColorsForDate:(nonnull NSDate *)date
{
    if ([self calendar:calendar subtitleForDate:date]) {
        return @[appearance.eventDefaultColor];
    }
    if ([_datesWithEvent containsObject:[self.dateFormatter2 stringFromDate:date]]) {
        return @[[UIColor whiteColor]];
    }
    return nil;
}

//#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    CalendarConfigViewController *config = segue.destinationViewController;
//    config.lunar = self.lunar;
//    config.theme = self.theme;
//    config.selectedDate = self.calendar.selectedDate;
//    config.firstWeekday = self.calendar.firstWeekday;
//    config.scrollDirection = self.calendar.scrollDirection;
//}
//
//- (void)unwind2StoryboardExample:(UIStoryboardSegue *)segue
//{
//    CalendarConfigViewController *config = segue.sourceViewController;
//    self.lunar = config.lunar;
//    self.theme = config.theme;
//    [self.calendar selectDate:config.selectedDate scrollToDate:NO];
//
//    if (self.calendar.firstWeekday != config.firstWeekday) {
//        self.calendar.firstWeekday = config.firstWeekday;
//    }
//
//    if (self.calendar.scrollDirection != config.scrollDirection) {
//        self.calendar.scrollDirection = config.scrollDirection;
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"FSCalendar" message:[NSString stringWithFormat:@"Now swipe %@",@[@"Vertically", @"Horizontally"][self.calendar.scrollDirection]] preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
//}


#pragma mark - Private properties

- (void)setTheme:(NSInteger)theme
{
    if (_theme != theme) {
        _theme = theme;
        switch (theme) {
            case 0: {
                _calendar.appearance.weekdayTextColor = FSCalendarStandardTitleTextColor;
                _calendar.appearance.headerTitleColor = FSCalendarStandardTitleTextColor;
                _calendar.appearance.eventDefaultColor = FSCalendarStandardEventDotColor;
                _calendar.appearance.selectionColor = FSCalendarStandardSelectionColor;
                _calendar.appearance.headerDateFormat = @"MMMM yyyy";
                _calendar.appearance.todayColor = FSCalendarStandardTodayColor;
                _calendar.appearance.borderRadius = 1.0;
                _calendar.appearance.headerMinimumDissolvedAlpha = 0.2;
                break;
            }
            case 1: {
                _calendar.appearance.weekdayTextColor = [UIColor redColor];
                _calendar.appearance.headerTitleColor = [UIColor darkGrayColor];
                _calendar.appearance.eventDefaultColor = [UIColor greenColor];
                _calendar.appearance.selectionColor = [UIColor blueColor];
                _calendar.appearance.headerDateFormat = @"yyyy-MM";
                _calendar.appearance.todayColor = [UIColor redColor];
                _calendar.appearance.borderRadius = 1.0;
                _calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
                
                break;
            }
            case 2: {
                _calendar.appearance.weekdayTextColor = [UIColor redColor];
                _calendar.appearance.headerTitleColor = [UIColor redColor];
                _calendar.appearance.eventDefaultColor = [UIColor greenColor];
                _calendar.appearance.selectionColor = [UIColor blueColor];
                _calendar.appearance.headerDateFormat = @"yyyy/MM";
                _calendar.appearance.todayColor = [UIColor orangeColor];
                _calendar.appearance.borderRadius = 0;
                _calendar.appearance.headerMinimumDissolvedAlpha = 1.0;
                break;
            }
            default:
                break;
        }
        
    }
}

- (void)setLunar:(BOOL)lunar
{
    if (_lunar != lunar) {
        _lunar = lunar;
        [_calendar reloadData];
    }
}

@end


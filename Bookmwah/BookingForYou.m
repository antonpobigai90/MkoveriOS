//
//  BookingForYou.m
//  Bookmwah
//
//  Created by admin on 10/06/16.
//  Copyright © 2016 Mahesh Kumar Dhakad. All rights reserved.
//1-Pending / 2-Completed / 3-Confirmed / 4-Rejected / 5-Cancelled by customer / 6-Cancelled by provider

#import "BookingForYou.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
@interface BookingForYou ()

@end
@implementation BookingForYou
@synthesize booking,aryCellIndex,table_section;
- (void)viewDidLoad {
    [super viewDidLoad];
    booking = [BookingForYouCell new];
    aryCellIndex = [NSMutableArray new];
    self.aryFinalSameDate = [NSMutableArray new];
    
    self.dictRespon = [NSMutableDictionary new];
    self.arrybooking = [NSMutableArray new];
    self.set = [NSSet new];
    
    UIView* footerView = [[UIView alloc] init];
    [_table_view setTableFooterView:footerView];
}

-(void)viewWillAppear:(BOOL)animated {
    [self Call_Bookforyou];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Call AcceptBooking/RejectBooking API
#pragma mark -
-(void) acceptBooking:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_table_view];
    
    NSIndexPath *indexPath = [_table_view indexPathForRowAtPoint:buttonPosition];
  
    NSArray *sectionRows = [_aryFinalSameDate  objectAtIndex:indexPath.section];
    NSString *strBookid  = [[sectionRows objectAtIndex:indexPath.row]valueForKey:@"book_id"];
    NSLog(@"%@",strBookid);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:strBookid forKey:@"book_id"];
    [dict setValue:@"1" forKey:@"status"];
    [dict setValue:[[sectionRows objectAtIndex:indexPath.row]valueForKey:@"u_id"] forKey:@"u_id"];
    
    [WebService call_API:dict andURL:API_BOOKING_ACCEPT_REJECT andImage:nil andImageName:nil andFileName:nil OnResultBlock:^(id response, MDDataTypes mdDataType, NSString *status) {
          
        NSString *sts = [response objectForKey:@"status"];
         
        if ([sts isEqualToString:@"true"])
        {
            [_aryFinalSameDate removeAllObjects];
            [self Call_Bookforyou];
        }
        else
        {
            _AlertView_WithOut_Delegate(@"Message",[response objectForKey:@"message"], @"OK", nil);
        }
    }];

}

-(void)RejectBooking:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_table_view];
    NSIndexPath *indexPath = [_table_view indexPathForRowAtPoint:buttonPosition];
    
    NSArray *sectionRows = [_aryFinalSameDate  objectAtIndex:indexPath.section];
    NSString *strBookid  = [[sectionRows objectAtIndex:indexPath.row] valueForKey:@"book_id"];
    NSLog(@"%@",strBookid);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:strBookid forKey:@"book_id"];
    [dict setValue:@"2" forKey:@"status"];
    [dict setValue:[[sectionRows objectAtIndex:indexPath.row]valueForKey:@"u_id"] forKey:@"u_id"];
    
    [WebService call_API:dict andURL:API_BOOKING_ACCEPT_REJECT andImage:nil andImageName:nil andFileName:nil OnResultBlock:^(id response, MDDataTypes mdDataType, NSString *status) {

        
        NSString * sts = [response objectForKey:@"status"];
        if ([sts isEqualToString:@"true"])
        {
            [_aryFinalSameDate removeAllObjects];
            [self Call_Bookforyou];
        }
        else
        {
            _AlertView_WithOut_Delegate(@"Message",[response objectForKey:@"message"], @"OK", nil);
        }
    }];

}

#pragma mark - Call CancelBooking API
#pragma mark -

-(void)action_chat:(UIButton *)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:_table_view];
    NSIndexPath *indexPath = [_table_view indexPathForRowAtPoint:buttonPosition];
    
    NSArray *sectionRows = [_aryFinalSameDate  objectAtIndex:indexPath.section];
    
    ChatDetailVC *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatDetailVC"];
    
    chatVC.strUserName = [[sectionRows objectAtIndex:btn.tag] valueForKey:@"u_fullname"];
    chatVC.selected_user_id = [[sectionRows objectAtIndex:btn.tag] valueForKey:@"u_id"];
                            
    NSString *someAvatar = [[sectionRows objectAtIndex:indexPath.row] valueForKey:@"u_image"];
    if ([someAvatar isEqualToString:@""]) {
        chatVC.someelseAvataImage = [UIImage imageNamed:@"small_default_img"];
    } else {
        chatVC.someelseAvataImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:someAvatar]]];
    }
    
    NSString *myAvatar = [NSUD valueForKey:@"u_image"];
    
    if ([myAvatar isEqualToString:@""]) {
        chatVC.myAvataImage = [UIImage imageNamed:@"small_default_img"];
    } else {
        chatVC.myAvataImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:myAvatar]]];
    }
    
    [self presentViewController:chatVC animated:NO completion:nil];
}

-(void)CancelBooking:(UIButton *)btn
{

    NSArray *sectionRows = [_aryFinalSameDate  objectAtIndex:btn.tag];
    NSString *bookid =[NSString stringWithFormat:@"%@",[[sectionRows objectAtIndex:btn.tag]valueForKey:@"book_id"]];
    NSLog(@"%@",bookid);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:bookid forKey:@"book_id"];
    [dict setValue:@"2" forKey:@"user_type"];
    
    [WebService call_API:dict andURL:API_CANCEL_BOOKING andImage:nil andImageName:nil andFileName:nil OnResultBlock:^(id response, MDDataTypes mdDataType, NSString *status) {

        
        NSString *sts = [response objectForKey:@"status"];
        if ([sts isEqualToString:@"true"])
        {
            [self Call_Bookforyou];
            
            [_table_view reloadData];
            
            CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:_table_view];
            NSIndexPath *indexPath = [_table_view indexPathForRowAtPoint:buttonPosition];
            BookingForYouCell *cell = (BookingForYouCell*)[_table_view cellForRowAtIndexPath:indexPath];
            
            [cell.btn_chat setHidden:false];
            
        }
        else
        {
            _AlertView_WithOut_Delegate(@"Message",[response objectForKey:@"message"], @"OK", nil);
        }
    }];

}
#pragma mark - Tableview Delegate
#pragma mark -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _set.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionRows = [_aryFinalSameDate  objectAtIndex:section];
    return sectionRows.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 10, self.view.frame.size.width, 23);
    title.textColor = [UIColor blackColor];
    title.font = [UIFont fontWithName:@"Corbel" size:16];
    title.textAlignment = NSTextAlignmentCenter;
    
    NSMutableArray *arrayDates = [NSMutableArray arrayWithArray:[self.set allObjects]];
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    NSArray *sorters = [[NSArray alloc] initWithObjects:sorter, nil];
    NSArray *sortedArray = [arrayDates sortedArrayUsingDescriptors:sorters];
    NSMutableArray *sortArray = [[NSMutableArray alloc] init];
    [sortArray addObjectsFromArray:sortedArray];
    NSLog(@"sortArray : %@",sortArray);
    NSString *str = [sortedArray objectAtIndex:section];
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];
    
    if([str isEqualToString:convertedDateString]) {
        title.text =@"Today";
    } else {
        title.text =str;
    }
    
    title.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [view setBackgroundColor:[WebService colorWithHexString:@"#eeeeee"]];
    [view addSubview:title];
   // [view viewWithTag:section];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    booking = [tableView dequeueReusableCellWithIdentifier:@"BookingForYouCell" forIndexPath:indexPath];
    NSArray *sectionRows = [_aryFinalSameDate  objectAtIndex:indexPath.section];
    booking.lbl_Bookingtime.text = [NSString stringWithFormat:@"%@ ~ %@", [[sectionRows objectAtIndex:indexPath.row] valueForKey:@"book_time"], [[sectionRows objectAtIndex:indexPath.row] valueForKey:@"book_to_time"]];
    
    NSString * StrRecieverId = [[self.arrybooking objectAtIndex:indexPath.row] valueForKey:@"u_id"];
    [NSUD setObject:StrRecieverId forKey:@"u_id"];
    
    booking.lbl_Name.text = [[sectionRows objectAtIndex:indexPath.row] valueForKey:@"s_name"];
    
    booking.lbl_Servicetype.text = [[sectionRows objectAtIndex:indexPath.row] valueForKey:@"s_cat_name"];
    
    NSString *imgURL = [[sectionRows objectAtIndex:indexPath.row] valueForKey:@"u_image"];
   
    booking.image_View.layer.cornerRadius = 25.0;
    booking.image_View.clipsToBounds = YES;
    
    [booking.image_View setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"small_default_img"]];
    
    NSString *book_status = [[sectionRows objectAtIndex:indexPath.row] valueForKey:@"book_status"];
    if ([book_status isEqualToString:@"1"])
    {
        booking.btn_Accept.hidden=false;
        booking.btn_reject.hidden=false;
        booking.btn_chat.hidden = true;
    }
    else if ([book_status isEqualToString:@"3"])
    {
        booking.btn_Accept.hidden=true;
        booking.btn_reject.hidden=true;
        booking.btn_chat.hidden = false;
    }
    
    table_section=indexPath.section;
    booking.btn_Accept.tag = indexPath.row ;
    [booking.btn_Accept addTarget:self action:@selector(acceptBooking:) forControlEvents:UIControlEventTouchUpInside];
    
    booking.btn_reject.tag = indexPath.row ;
    [booking.btn_reject addTarget:self action:@selector(RejectBooking:) forControlEvents:UIControlEventTouchUpInside];
   
    booking.btn_chat.tag = indexPath.row ;
    [booking.btn_chat addTarget:self action:@selector(action_chat:) forControlEvents:UIControlEventTouchUpInside];

    return booking;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookingDetailVC *bookingDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingDetailVC"];
    
    NSMutableArray *arr = [_aryFinalSameDate objectAtIndex:indexPath.section];
    NSDictionary *dict = [arr objectAtIndex:indexPath.row];
    
    bookingDetail.userInfoDic = dict;
    [self presentViewController:bookingDetail animated:NO completion:nil];
}

#pragma mark - Call Book for you API
#pragma mark -
-(void)Call_Bookforyou
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSString *pro_id = [NSUD valueForKey:@"pro_id"];
    [dict setValue:pro_id forKey:@"pro_id"];
    
    [WebService call_API:dict andURL:API_BOOKING4U andImage:nil andImageName:nil andFileName:nil OnResultBlock:^(id response, MDDataTypes mdDataType, NSString *status) {

        NSString * sts = [response objectForKey:@"status"];
        if ([sts isEqualToString:@"true"])
        {
            NSLog(@"%@",response);
            self.dictRespon = response;
            self.arrybooking = [response valueForKey:@"bookings"];
            
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
            
            for (NSString *strDate in sortArray) {
                [self Set_Row_insection:strDate];
            }
            _table_view.delegate =self;
            _table_view.dataSource =self;
            NSLog(@"%@",self.set);
            [_table_view reloadData];
        }
        else
        {
            _AlertView_WithOut_Delegate(@"Message",[response objectForKey:@"message"], @"OK", nil);
        }
    }];
}


-(void)Set_Row_insection:(NSString *)date
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
    [_aryFinalSameDate addObject:arraySectionRowcount];
      NSLog(@"Finel Array%@",_aryFinalSameDate);
}

#pragma mark - @end
#pragma mark -

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}




@end

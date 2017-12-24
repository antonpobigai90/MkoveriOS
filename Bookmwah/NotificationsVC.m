//
//  NotificationsVC.m
//  Bookmwah
//
//  Created by admin on 04/06/16.
//  Copyright © 2016 Mahesh Kumar Dhakad. All rights reserved.
//

#import "NotificationsVC.h"
#import "Constant.h"

@interface NotificationsVC ()
{
    NSString *btnName;
    MBProgressHUD *HUD;
}

@end

@implementation NotificationsVC

@synthesize tv, notificationArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate getMissedChats];
    
    UIView* footerView = [[UIView alloc] init];
    [tv setTableFooterView:footerView];
}

-(void)viewWillAppear:(BOOL)animated {
    btnName = @"Cancel";
    [self call_NotificationListAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)call_NotificationListAPI{
    
    [HUD show:YES];
    
    NSString *user_id =[NSUD valueForKey:@"user_id"];
    NSLog(@"User id %@",user_id);
    
    NSMutableDictionary *user_dic = [NSMutableDictionary new];
    [user_dic setValue:user_id forKey:@"u_id"];
    
    NSLog(@"%@",user_dic);
    
    [WebService call_API:user_dic andURL:API_NOTIFICATION_LIST andImage:nil andImageName:nil andFileName:nil OnResultBlock:^(id response, MDDataTypes mdDataType, NSString *status) {
        
        if([[response valueForKey:@"status"] isEqualToString:@"true"])
        {
            NSLog(@"%@",response);
            notificationArray = [response objectForKey:@"notification"];
            [tv reloadData];
            [HUD hide:YES];
        }else{
            
            NSString *strMsg = [response objectForKey:@"message"];
            
            if ([strMsg  isEqual: @"There is no data"]) {
                
            }else{
                _AlertView_WithOut_Delegate(@"Message",[response objectForKey:@"message"], @"OK", nil);
            }
            [HUD hide:YES];
        }
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return notificationArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"NotificationsTVCell";
    
    NotificationsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationsTVCell" owner:self options:nil];
    
    cell = [nib objectAtIndex:0];
    
    NSMutableDictionary *dic = [notificationArray objectAtIndex:indexPath.row];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (![[dic valueForKey:@"noti_msg"] isEqualToString:@"Your booking has been accepted"]) {
        cell.lblMessage.textColor = [WebService colorWithHexString:@"#ef2e2e"];
    }
    
    cell.lbl_Name.text = [dic valueForKey:@"u_fullname"];
    cell.lbl_ServiceType.text = [dic valueForKey:@"s_cat_name"];
    cell.lbl_BookingTime.text = [NSString stringWithFormat:@"%@ %@~%@", [dic valueForKey:@"book_date"], [dic valueForKey:@"book_time"], [dic valueForKey:@"book_to_time"]];
    cell.lblMessage.text = [dic valueForKey:@"noti_msg"];
    cell.btn_cancel.tag = indexPath.row;
    [cell.btn_cancel addTarget:self action:@selector(callMethods:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}

-(void)callMethods:(UIButton *)sender {
    
    NSMutableDictionary *dic = [notificationArray objectAtIndex:sender.tag];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:[dic valueForKey:@"noti_id"] forKey:@"noti_id"];
    
    NSString *user_id =[NSUD valueForKey:@"user_id"];
    NSLog(@"User id %@",user_id);
    
    [dict setValue:user_id forKey:@"u_id"];
    
    [WebService call_API:dict andURL:API_NOTIFICATION_REMOVE andImage:nil andImageName:nil andFileName:nil OnResultBlock:^(id response, MDDataTypes mdDataType, NSString *status) {
        
        NSString *sts = [response objectForKey:@"status"];
        
        if ([sts isEqualToString:@"true"])
        {
            [notificationArray removeAllObjects];
            notificationArray = [response objectForKey:@"notification"];
            [tv reloadData];
        }
        else
        {
            _AlertView_WithOut_Delegate(@"Message",[response objectForKey:@"message"], @"OK", nil);
        }
    }];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

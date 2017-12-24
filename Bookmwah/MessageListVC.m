//
//  Menu.m
//  Bookmwah
//
//  Created by admin on 23/05/16.
//  Copyright © 2016 Mahesh Kumar Dhakad. All rights reserved.
//

#import "MessageListVC.h"
#import "Constant.h"
#import "MessageListTableViewCell.h"

@interface MessageListVC ()
{
    MBProgressHUD *HUD;
}

@end

@implementation MessageListVC

@synthesize messageTV;

#pragma mark - View Lifecycle Methods
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* footerView = [[UIView alloc] init];
    [messageTV setTableFooterView:footerView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self call_ChatListAPI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)call_ChatListAPI{
    
    [HUD show:YES];
    
    NSString *user_id =[NSUD valueForKey:@"user_id"];
    NSLog(@"User id %@",user_id);
    
    NSMutableDictionary *user_dic = [NSMutableDictionary new];
    [user_dic setValue:user_id forKey:@"sender_id"];
    
    NSLog(@"%@",user_dic);
    
    [WebService call_API:user_dic andURL:API_CHAT_USER_LIST andImage:nil andImageName:nil andFileName:nil OnResultBlock:^(id response, MDDataTypes mdDataType, NSString *status) {
        
        if([[response valueForKey:@"status"] isEqualToString:@"true"])
        {
            
            NSLog(@"%@",response);
            arrayUserList = [response objectForKey:@"records"];
            [messageTV reloadData];
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
#pragma mark - Tableview Delegate Methods
#pragma mark -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayUserList.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"messageCell";

    MessageListTableViewCell *cell = [messageTV dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSMutableDictionary *dic = [arrayUserList objectAtIndex:indexPath.row];
    
    NSString *someAvatar = [dic valueForKey:@"u_image"];
    [cell.User_img setImageWithURL:[NSURL URLWithString:someAvatar] placeholderImage:[UIImage imageNamed:@"small_default_img"]];
    
    cell.lblName.text = [dic valueForKey:@"name"];
    cell.lblMsg.text = [dic valueForKey:@"message"];
    cell.lblDate.text = [dic valueForKey:@"datetime"];
    
    if ([[dic valueForKey:@"count"] isEqualToString:@"0"]) {
        cell.lblCount.hidden = true;
    } else {
        cell.lblCount.text = [dic valueForKey:@"count"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = [arrayUserList objectAtIndex:indexPath.row];
    
    ChatDetailVC *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatDetailVC"];
    
    chatVC.strUserName = [dic valueForKey:@"name"];
    chatVC.selected_user_id = [dic valueForKey:@"u_id"];
    
    NSString *someAvatar = [dic valueForKey:@"u_image"];
    if ([someAvatar isEqualToString:@""]) {
        chatVC.someelseAvataImage = [UIImage imageNamed:@"small_default_img"];
    } else {
        chatVC.someelseAvataImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: someAvatar]]];
    }
    
    NSString *myAvatar = [NSUD valueForKey:@"u_image"];
    
    if ([myAvatar isEqualToString:@""]) {
        chatVC.myAvataImage = [UIImage imageNamed:@"small_default_img"];
    } else {
        chatVC.myAvataImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:myAvatar]]];
    }
    
    [self presentViewController:chatVC animated:NO completion:nil];
}


- (IBAction)Back_btn:(id)sender {
     [self dismissViewControllerAnimated:NO completion:nil];
}

@end

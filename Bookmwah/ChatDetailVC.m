//
//  Menu.m
//  Bookmwah
//
//  Created by admin on 23/05/16.
//  Copyright © 2016 Mahesh Kumar Dhakad. All rights reserved.
//

#import "ChatDetailVC.h"
#import "Constant.h"

@interface ChatDetailVC ()
{
    CGSize kbSize;
    MBProgressHUD *HUD;
    NSString *receive_id;
    UIImage *image;
    
    NSMutableArray *m_arrayData;
}

@end

@implementation ChatDetailVC
@synthesize userName, strUserName, txt_chat, chat_tableView, sendView, someelseAvataImage, myAvataImage;
#pragma mark - View Lifecycle Methods
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.m_curChatViewCon = self;
    
    txt_chat.delegate = self;
    
    m_arrayData = [[NSMutableArray alloc] init];
    
    userName.text = strUserName;
    
    chat_tableView.bubbleDataSource = self;
    chat_tableView.snapInterval = 120;
    chat_tableView.showAvatars = YES;
    chat_tableView.typingBubble = NSBubbleTypingTypeNobody;
    [chat_tableView reloadData];
    
    //Tap Gesture
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    
    [self.view addGestureRecognizer:singleFingerTap];
    
    [self call_ChatAPI];
    
    [appDelegate getMissedChats];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Back_btn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark - call_ChatAPI
#pragma mark -

-(void)call_ChatAPI{
    
    [HUD show:YES];
    
    NSString *user_id =[NSUD valueForKey:@"user_id"];
    NSLog(@"User id %@",user_id);
    
    NSMutableDictionary *user_dic = [NSMutableDictionary new];
    [user_dic setValue:user_id forKey:@"sender_id"];
    [user_dic setValue:self.selected_user_id forKey:@"receive_id"];
    
    NSLog(@"%@",user_dic);
    
    [WebService call_API:user_dic andURL:API_CHAT_HISTORY andImage:nil andImageName:nil andFileName:nil OnResultBlock:^(id response, MDDataTypes mdDataType, NSString *status) {
        
        if([[response valueForKey:@"status"] isEqualToString:@"true"])
        {
            
            NSLog(@"%@",response);
            
            m_arrayData = [self getData:[response objectForKey:@"records"]];
            
            [chat_tableView reloadData];
            [self performSelector:@selector(tableViewScrollToBottom) withObject:nil afterDelay:0.3f];
            
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

-(NSMutableArray *)getData:(NSMutableArray *)data {
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSDictionary* info in data) {
        
        NSDate *created_date = [[NSDate date] dateByAddingTimeInterval:-1 * [[info valueForKey:@"date_time"] floatValue]];
        
        if (![[info objectForKey:@"sender_id"] isEqualToString:[NSUD valueForKey:@"user_id"]]) {
            
            NSBubbleData *heyBubble = [NSBubbleData dataWithText:[info objectForKey:@"message"] date:created_date type:BubbleTypeMine];
            
            heyBubble.avatar = someelseAvataImage;
            
            [temp addObject:heyBubble];
        } else {
            
            NSBubbleData *heyBubble = [NSBubbleData dataWithText:[info objectForKey:@"message"] date:created_date type:BubbleTypeSomeoneElse];
            
            heyBubble.avatar = myAvataImage;
            
            [temp addObject:heyBubble];
        }
    }
    
    return temp;
}

- (IBAction)message_send:(id)sender {
    if ([txt_chat.text compare:@""] == NSOrderedSame) {
        [txt_chat resignFirstResponder];
        return;
    }
    
    NSString *str_message = txt_chat.text;
    txt_chat.text = @"";
    
    NSDate *created_date = [[NSDate date] dateByAddingTimeInterval:0];
    
    NSBubbleData *heyBubble = [NSBubbleData dataWithText:str_message date:created_date type:BubbleTypeSomeoneElse];
    heyBubble.avatar = myAvataImage;
    
    [m_arrayData addObject:heyBubble];
    [chat_tableView reloadData];
    [self tableViewScrollToBottom];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self call_SendMessageAPI:str_message];
    });
}


#pragma mark - call_SendMessageAPI
#pragma mark -

-(void)call_SendMessageAPI:(NSString*)strSendText {
    
    [HUD show:YES];
    
    NSString *user_id =[NSUD valueForKey:@"user_id"];
    NSLog(@"User id %@",user_id);
    
    NSData *data = [strSendText dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *goodValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *user_dic = [NSMutableDictionary new];
    [user_dic setValue:goodValue forKey:@"message"];
    
    [user_dic setValue:user_id forKey:@"sender_id"];
    [user_dic setValue:self.selected_user_id forKey:@"receive_id"];
    
    NSLog(@"%@",user_dic);
    
  [WebService call_API:user_dic andURL:API_Send_Chat_Message andImage:nil andImageName:nil andFileName:nil OnResultBlock:^(id response, MDDataTypes mdDataType, NSString *status){
      
      
        if([[response valueForKey:@"status"] isEqualToString:@"true"])
        {
            NSLog(@"%@",response);
            
            [HUD hide:YES];
            
        }else{
            
            _AlertView_WithOut_Delegate(@"Message",[response objectForKey:@"message"], @"OK", nil);
            
            [HUD hide:YES];
            
        }
        
    }];
    
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

- (void)tableViewScrollToBottom
{
    NSLog(@"%@", m_arrayData);
    
    if (m_arrayData.count==0)
        return;
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([chat_tableView numberOfRowsInSection:([chat_tableView numberOfSections] - 1)] - 1) inSection:([chat_tableView numberOfSections] - 1)];
    [chat_tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark -

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView {
    return [m_arrayData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row {
    return [m_arrayData objectAtIndex:row];
}

- (void)showReceiveMessage:(NSDictionary *) dic
{
    NSString* strCurrentMessageText = [dic valueForKey:@"message"];
    strCurrentMessageText = [strCurrentMessageText stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    
    NSData *data = [strCurrentMessageText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *goodValue = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    
    NSLog(@"debug : received chat message = %@", goodValue);
    
    if (goodValue == nil || [goodValue isKindOfClass:[NSNull class]])
        return;
    
    NSDate *created_date = [[NSDate date] dateByAddingTimeInterval:0];
    
    NSBubbleData *heyBubble = [NSBubbleData dataWithText:goodValue date:created_date type:BubbleTypeMine];
    
    heyBubble.avatar = someelseAvataImage;
    
    [m_arrayData addObject:heyBubble];
    [chat_tableView reloadData];
    [self tableViewScrollToBottom];
}

#pragma UITextFieldDelegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end

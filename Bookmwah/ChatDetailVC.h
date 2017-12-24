//
//  Menu.h
//  Bookmwah
//
//  Created by admin on 23/05/16.
//  Copyright © 2016 Mahesh Kumar Dhakad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "UIBubbleTableView.h"

@class AppDelegate;

@interface ChatDetailVC : UIViewController<UITextFieldDelegate, UIBubbleTableViewDataSource, UITableViewDelegate>
{
    AppDelegate *appDelegate;
    
    NSDictionary *dic ;
    
    NSMutableArray *notificationArray;
}

@property (weak, nonatomic) NSString *strUserName;
@property (nonatomic, strong) UIImage *myAvataImage;
@property (nonatomic, strong) UIImage *someelseAvataImage;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (nonatomic, strong) NSString *selected_user_id;
@property (weak, nonatomic) IBOutlet UIBubbleTableView *chat_tableView;
@property (weak, nonatomic) IBOutlet UITextField *txt_chat;
@property (weak, nonatomic) IBOutlet UIView *sendView;

- (IBAction)Back_btn:(id)sender;
- (void)showReceiveMessage:(NSDictionary *) dic;
- (IBAction)message_send:(id)sender;

@end

//
//  Menu.h
//  Bookmwah
//
//  Created by admin on 23/05/16.
//  Copyright © 2016 Mahesh Kumar Dhakad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@class AppDelegate;

@interface MenuVC : UIViewController<MFMailComposeViewControllerDelegate>
{
    
    AppDelegate *appDelegate;
    
    NSMutableDictionary *dic ;
    NSMutableArray *notificationArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

- (IBAction)edit_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

- (IBAction)action_menu:(UIButton*)sender;

@property (weak, nonatomic) IBOutlet UILabel *msgBadge;
@property (weak, nonatomic) IBOutlet UILabel *notificationBadge;

@end

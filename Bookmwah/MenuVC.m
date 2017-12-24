//
//  Menu.m
//  Bookmwah
//
//  Created by admin on 23/05/16.
//  Copyright © 2016 Mahesh Kumar Dhakad. All rights reserved.
//

#import "MenuVC.h"
#import "Constant.h"
#import "MenuTableViewCell.h"

@interface MenuVC ()
{
    KYDrawerController *elDrawer;
    long count;
    
    MBProgressHUD *HUD;
}

@end

@implementation MenuVC
@synthesize msgBadge, notificationBadge;

#pragma mark - View Lifecycle Methods
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.m_curMenuViewCon = self;
 
    elDrawer = (KYDrawerController*)self.navigationController.parentViewController;
}

-(void)viewDidAppear:(BOOL)animated
{
    //cell.img_LogOut.image =
    _imgView.layer.cornerRadius = _imgView.frame.size.height/2;
    _imgView.layer.cornerRadius = _imgView.frame.size.width/2;
    _imgView.clipsToBounds = YES;
    _imgView.layer.borderColor = [WebService colorWithHexString:@"#00afdf"].CGColor;
    _imgView.layer.borderWidth = 1.0f;
    
    msgBadge.layer.cornerRadius = 15.0;
    msgBadge.layer.masksToBounds = YES;
    
    notificationBadge.layer.cornerRadius = 15.0;
    notificationBadge.layer.masksToBounds = YES;

}
-(void)viewWillAppear:(BOOL)animated
{
    [self setRightPanelValue];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setRightPanelValue
{
    _lblName.text = [NSUD valueForKey:@"u_fullname"];
    NSString *url = [NSUD valueForKey:@"u_image"];
    if ([[NSUD valueForKey:@"u_image"]isEqualToString:@""]) {
        _imgView.image = [UIImage imageNamed:@"big_default_img"];
    }
    else
    {
        [_imgView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"big_default_img"]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   // if (alertView.tag == 121 && buttonIndex == 1)
    
    if (buttonIndex == 1)
    {
        //code for opening settings app in iOS 8
       // [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
    
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
        NSLog(@"%@",UIApplicationOpenSettingsURLString);
    
    }
}

#pragma mark - MailComposer Delegate Methods

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)edit_btn:(id)sender {
    
    [elDrawer setDrawerState:KYDrawerControllerDrawerStateClosed animated:YES];
    
    AccountInfo *accountVC = (AccountInfo *) [self.storyboard instantiateViewControllerWithIdentifier:@"AccountInfo"];
    
    [self presentViewController:accountVC animated:NO completion:^{
    }];
}

-(void) logout {
    [HUD show:YES];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    NSString *u_id = [NSUD valueForKey:@"user_id"];
    
    [dict setValue: u_id forKey:@"user_id"];
    
    [WebService call_API:dict andURL:API_LogOut andImage:nil andImageName:nil OnResultBlock:^(id response, MDDataTypes mdDataType, NSString *status){
        
        [NSUD setValue:@"5" forKey:@"IS_LOGIN"];
        
        [NSUD removeObjectForKey:@"user_type"];
        
        [NSUD synchronize];
        
        SignInVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInVC"];
        [self presentViewController:vc animated:NO completion:nil];
        
        
        [HUD hide:YES];
        
    }];
}
- (IBAction)action_test:(id)sender {
    NSLog(@"sdfsd");
}

- (IBAction)action_menu:(UIButton*)sender {
    
    NSString *strUserType = [NSUD valueForKey:@"user_type"];
    
    if (sender.tag == 10) { //Home
        
        if([strUserType isEqual:@"1"]){
            TabBarVC *tabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
            
            UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:tabBarVC];
            
            [navController setNavigationBarHidden:YES];
            
            elDrawer.mainViewController=navController;
            [elDrawer setDrawerState:KYDrawerControllerDrawerStateClosed animated:YES];
        } else {
            [elDrawer setDrawerState:KYDrawerControllerDrawerStateClosed animated:YES];
            ServiceProviderTabBarVC *tabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ServiceProviderTabBarVC"];
            
            [self presentViewController:tabBarVC animated:NO completion:nil];
            [self.tabBarController setSelectedIndex:0];
            [[ServiceProviderTabBarVC new] change_TabBar:0];
        }
        
    } else if(sender.tag == 11) {   //Message
        
        [elDrawer setDrawerState:KYDrawerControllerDrawerStateClosed animated:YES];
        
        MessageListVC *messageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageListVC"];
        [self presentViewController:messageVC animated:YES completion:nil];
        
    } else if(sender.tag == 12) {   //Notification
        
        [elDrawer setDrawerState:KYDrawerControllerDrawerStateClosed animated:YES];
        
        NotificationsVC *notificationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationsVC"];
        notificationVC.notificationArray =notificationArray;
        [self presentViewController:notificationVC animated:YES completion:nil];
        
    } else if(sender.tag == 13) {   //Terms
        
        [elDrawer setDrawerState:KYDrawerControllerDrawerStateClosed animated:YES];
        
        TermsVC *termsVC = (TermsVC *) [self.storyboard instantiateViewControllerWithIdentifier:@"TermsVC"];
        
        [self presentViewController:termsVC animated:NO completion:^{
            
        }];
        
    } else if(sender.tag == 14) {   //Privacy
        
        [elDrawer setDrawerState:KYDrawerControllerDrawerStateClosed animated:YES];
        
        PrivacyVC *privacyVC = (PrivacyVC *) [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyVC"];
        
        [self   presentViewController:privacyVC animated:NO completion:^{
            
        }];
        
    } else if(sender.tag == 15) {   //About Us
        
        [elDrawer setDrawerState:KYDrawerControllerDrawerStateClosed animated:YES];
        
        AboutUsVC *aboutVC = (AboutUsVC *) [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUsVC"];
        
        [self   presentViewController:aboutVC animated:NO completion:^{
            
        }];
        
    } else if(sender.tag == 16) {   //Logout
        [self logout];
    }
}
@end

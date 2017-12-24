//
//  bookingDetailVC.m
//  Bookmwah
//
//  Created by admin on 16/06/16.
//  Copyright © 2016 Mahesh Kumar Dhakad. All rights reserved.
//

#import "BookingDetailVC.h"
#import "Constant.h"

@interface BookingDetailVC ()

@end

@implementation BookingDetailVC
@synthesize userInfoDic;

- (void)viewDidLoad {
    [super viewDidLoad];

    _detailsView.layer.cornerRadius = 5.0;
    _detailsView.layer.masksToBounds = TRUE;
    
    _lbl_serviceType.text = [userInfoDic valueForKey:@"s_name"];
    _lbl_name.text = [userInfoDic valueForKey:@"u_fullname"];
    _lbl_Email.text = [userInfoDic valueForKey:@"u_email"];
    NSString *str = [userInfoDic valueForKey:@"u_gender"];

    if([str isEqualToString:@"1"])
      _lbl_gender.text =@"Male";
    else
      _lbl_gender.text=@"Female";

    _lbl_MobileNumber.text = [userInfoDic valueForKey:@"u_mobile_no"];
    _lbl_BookingDate.text = [userInfoDic valueForKey:@"book_date"];
    _lbl_BookingTime.text = [NSString stringWithFormat:@"%@ ~ %@", [userInfoDic valueForKey:@"book_time"], [userInfoDic valueForKey:@"book_to_time"]];
    _lbl_Address.text = [userInfoDic valueForKey:@"book_addr"];
    
    NSString *someAvatar = [userInfoDic valueForKey:@"u_image"];
    [_image_Profile setImageWithURL:[NSURL URLWithString:someAvatar] placeholderImage:[UIImage imageNamed:@"small_default_img"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated {

  _image_Profile.layer.cornerRadius = _image_Profile.frame.size.width / 2;
  _image_Profile.clipsToBounds = YES;
   
}

- (IBAction)action_accept:(id)sender {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:[userInfoDic valueForKey:@"book_id"] forKey:@"book_id"];
    [dict setValue:@"1" forKey:@"status"];
    [dict setValue:[userInfoDic valueForKey:@"u_id"] forKey:@"u_id"];
    
    [WebService call_API:dict andURL:API_BOOKING_ACCEPT_REJECT andImage:nil andImageName:nil andFileName:nil OnResultBlock:^(id response, MDDataTypes mdDataType, NSString *status) {
        
        if ([@"false" isEqualToString:[response objectForKey:@"status"]]) {
            _AlertView_WithOut_Delegate(@"Message",[response objectForKey:@"message"], @"OK", nil);
        } else {
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

- (IBAction)action_reject:(id)sender {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:[userInfoDic valueForKey:@"book_id"] forKey:@"book_id"];
    [dict setValue:@"2" forKey:@"status"];
    [dict setValue:[userInfoDic valueForKey:@"u_id"] forKey:@"u_id"];
    
    [WebService call_API:dict andURL:API_BOOKING_ACCEPT_REJECT andImage:nil andImageName:nil andFileName:nil OnResultBlock:^(id response, MDDataTypes mdDataType, NSString *status) {
        
        if ([@"false" isEqualToString:[response objectForKey:@"status"]]) {
            _AlertView_WithOut_Delegate(@"Message",[response objectForKey:@"message"], @"OK", nil);
        } else {
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

- (IBAction)action_cancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end

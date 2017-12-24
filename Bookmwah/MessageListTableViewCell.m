//
//  MenuTableViewCell.m
//  Bookmwah
//
//  Created by admin on 24/05/16.
//  Copyright © 2016 Mahesh Kumar Dhakad. All rights reserved.
//

#import "MessageListTableViewCell.h"

@implementation MessageListTableViewCell

@synthesize lblName,lblDate,lblMsg, User_img, lblCount;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.User_img.layer.cornerRadius = 25.0;
    self.User_img.clipsToBounds = YES;
    
    self.lblCount.layer.cornerRadius = 12.5;
    self.lblCount.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    
    [super setSelected:selected animated:animated];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    // Configure the view for the selected state
}

@end

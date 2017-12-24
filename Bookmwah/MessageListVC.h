//
//  Menu.h
//  Bookmwah
//
//  Created by admin on 23/05/16.
//  Copyright © 2016 Mahesh Kumar Dhakad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"


@interface MessageListVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arrayUserList;
}
@property (weak, nonatomic) IBOutlet UITableView *messageTV;

- (IBAction)Back_btn:(id)sender;

@end

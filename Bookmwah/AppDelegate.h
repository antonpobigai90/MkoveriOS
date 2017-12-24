//
//  AppDelegate.h
//  Bookmwah
//
//  Created by Developer on 13/05/16.
//  Copyright © 2016 Mahesh Kumar Dhakad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVC.h"
#import "MenuVC.h"
#import "Constant.h"

@class ChatDetailVC;
@class MenuVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) ChatDetailVC* m_curChatViewCon;
@property (nonatomic, strong) MenuVC* m_curMenuViewCon;

@property (nonatomic, readwrite) int gNotificationCount;

- (void) getMissedChats;

@end


//
//  TermsVC.h
//  Bookmwah
//
//  Created by admin on 19/05/16.
//  Copyright © 2016 Mahesh Kumar Dhakad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@interface TermsVC : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)back:(id)sender;

@end

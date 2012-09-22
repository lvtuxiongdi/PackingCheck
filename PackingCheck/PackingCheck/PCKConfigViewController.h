//
//  PCKConfigFolderViewController.h
//  PackingCheck
//
//  Created by nanfang on 7/12/12.
//  Copyright (c) 2012 lvtuxiongdi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGlossyButton.h"


@protocol PCKConfigDelegate <NSObject>
-(void)feedback;
-(void)about;
@end

@interface PCKConfigViewController : UIViewController
@property(unsafe_unretained) id<PCKConfigDelegate> delegate;
@property(strong, nonatomic) UIGlossyButton * feedbackButton;
@property(strong, nonatomic) UIGlossyButton * aboutButton;
@end

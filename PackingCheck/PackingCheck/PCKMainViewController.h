//
//  PCKViewController.h
//  PackingCheck
//
//  Created by nanfang on 7/7/12.
//  Copyright (c) 2012 lvtuxiongdi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCKCheckListViewController.h"
#import "PCKConfigViewController.h"
#import "SEMenuItem.h"
#import "PCKSpringBoard.h"
#import "PCKCommon.h"

@interface PCKMainViewController : UIViewController<PCKCheckListDelegate, PCKConfigDelegate>

@property (nonatomic, strong) PCKConfigViewController *configViewController;

- (void)startSetting;

@end

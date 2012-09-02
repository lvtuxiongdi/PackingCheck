//
//  PCKAddItemController.h
//  PackingCheck
//
//  Created by nanfang on 8/21/12.
//  Copyright (c) 2012 lvtuxiongdi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PCKAddItemDelegate
-(void)addItems:(NSArray*)items;
@end

@interface PCKAddItemController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (unsafe_unretained) id<PCKAddItemDelegate> delegate;
@property NSMutableSet* filterItemIds;
@end

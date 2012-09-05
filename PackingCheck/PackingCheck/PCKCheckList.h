//
//  PCKCheckList.h
//  PackingCheck
//
//  Created by nanfang on 7/7/12.
//  Copyright (c) 2012 lvtuxiongdi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCKModel.h"
@interface PCKCheckList : PCKModel
@property(nonatomic) int listId;
@property(strong, nonatomic) NSString * name;
@property(strong, nonatomic) NSString * imageName;

- (id)initWithId:(int)listId name:(NSString*)name imageName:(NSString*)imageName;
- (void)increaseOpens;
- (NSMutableArray*) items;
- (void)addItems:(NSArray*)items;
- (void)removeItemWithId:(int)itemId;

+ (NSMutableArray*) all;
+ (PCKCheckList*)createWithName:(NSString*)name imageName:(NSString*)imageName;
@end

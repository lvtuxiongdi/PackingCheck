//
//  PCKCheckList.m
//  PackingCheck
//
//  Created by nanfang on 7/7/12.
//  Copyright (c) 2012 lvtuxiongdi.com. All rights reserved.
//

#import "PCKCheckList.h"
#import "FMDatabase.h"
#import "PCKCommon.h"
#import "DBUtils.h"
#import "PCKItem.h"
#import "PCKConstants.h"

@implementation PCKCheckList
@synthesize name=_name, listId=_listId, imageName=_imageName, nameEn=_nameEn;
- (id)initWithId:(int)listId name:(NSString*)name imageName:(NSString*)imageName
{
    self = [super init];
    if (self) {
        self.listId = listId;
        self.name = name;
        self.imageName = imageName;
    }
    return self;

}

- (id)initWithResultSet:(FMResultSet*)rs
{
    self = [self initWithId:[(NSNumber *)[rs objectForColumnName:@"id"] intValue]  
                       name:[rs objectForColumnName:@"name"] 
                    imageName:[rs objectForColumnName:@"image_name"]];
    self.nameEn = [rs objectForColumnName:@"name_en"];
    return self;
}

- (void)increaseOpens
{    
    FMDatabase* db = [PCKCommon database];
    [db executeUpdate:@"UPDATE check_list SET opens=opens+1 WHERE id=?", @(self.listId)];
}

- (NSMutableArray*) items
{
    return [[PCKItem class] find:@"SELECT i.* FROM item i INNER JOIN list_item l ON i.id=l.item_id AND l.list_id=? ORDER BY l.item_order desc", @(self.listId)];
}

- (NSMutableArray*) checkedItems
{
    return [[PCKItem class] find:@"SELECT i.* FROM item i INNER JOIN list_item l ON i.id=l.item_id AND l.list_id=? AND l.status=? ORDER BY l.item_order desc", @(self.listId), @(ITEM_CHECKED)];
}

- (NSString *)i18nName
{
    
    if(!self.nameEn || [[NSNull null] isEqual:self.nameEn]){
        return self.name;
    }
    
    NSString* strLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    
    
    if([strLanguage isEqualToString:@"zh-Hans"]){
        return self.name;
    }

    return self.nameEn;
}


- (void)addItems:(NSArray*)items{
    // TODO transaction
    FMDatabase* db = [PCKCommon database];
    [db beginTransaction];
    FMResultSet* rs = [db executeQuery:@"SELECT i.id FROM item i INNER JOIN list_item l ON i.id=l.item_id AND l.list_id=?", @(self.listId)];
    NSMutableSet * ids = [NSMutableSet set];
    while([rs next]){
        [ids addObject:@([rs intForColumn:@"id"])];
    }
    
    for(PCKItem* item in items){
        if(![ids containsObject:@(item.itemId)]){
            [db executeUpdate:@"INSERT INTO list_item(list_id, item_id) values (?,?)", @(self.listId), @(item.itemId)];
        }
    }
    [db commit];
}

- (void)reorderItems:(NSArray*)items
{
    FMDatabase* db = [PCKCommon database];
    [db beginTransaction];
    int i = [items count];
    for(PCKItem * item in items){
        [db executeUpdate:@"UPDATE list_item SET item_order=? WHERE list_id=? AND item_id=?",@(i--), @(_listId), @(item.itemId)];
    }
    [db commit];
}

- (void)removeItemWithId:(int)itemId
{
    FMDatabase* db = [PCKCommon database];
    [db executeUpdate:@"DELETE FROM list_item WHERE list_id=? AND item_id=?", @(_listId), @(itemId)];
}


- (void)checkItemWithId:(int)itemId
{
    FMDatabase* db = [PCKCommon database];
    [db executeUpdate:@"UPDATE list_item SET status=? WHERE list_id=? AND item_id=?", @(ITEM_CHECKED), @(_listId), @(itemId)];
}


- (void)uncheckItemWithId:(int)itemId
{
    FMDatabase* db = [PCKCommon database];
    [db executeUpdate:@"UPDATE list_item SET status=? WHERE list_id=? AND item_id=?", @(ITEM_UNCHECKED), @(_listId), @(itemId)];
}

- (void)uncheckAllItems
{
    FMDatabase* db = [PCKCommon database];
    [db executeUpdate:@"UPDATE list_item SET status=? WHERE list_id=?", @(ITEM_UNCHECKED), @(_listId)];
}

- (BOOL)isChecking
{
    FMDatabase* db = [PCKCommon database];
    FMResultSet* rs = [db executeQuery:@"SELECT COUNT(1) FROM list_item WHERE status=? AND list_id=? ", @(ITEM_CHECKED), @(self.listId)];
    if([rs next]){
        int totalCount = [rs intForColumnIndex:0];
        if(totalCount > 0){
            return YES;
        }
    }
    return NO;
}


+ (void)removeById:(int)listId
{
    FMDatabase* db = [PCKCommon database];
    [db beginTransaction];
    [db executeUpdate:@"DELETE FROM list_item WHERE list_id=?", @(listId)];
    [db executeUpdate:@"DELETE FROM check_list WHERE id=?", @(listId)];
    [db commit];
    [MobClick event:EVENT_REMOVE_LIST];
}

+ (NSMutableArray*) all
{
    return [self find:@"SELECT * FROM check_list ORDER BY opens DESC"];
}

+ (PCKCheckList*)createWithName:(NSString*)name imageName:(NSString*)imageName
{
    FMDatabase* db = [PCKCommon database];
    [db executeUpdate:@"INSERT INTO check_list(name, image_name) VALUES (?, ?)", name, imageName];
    int listId = [db lastInsertRowId];
    PCKCheckList* checkList = [[PCKCheckList alloc]initWithId:listId name:name imageName:imageName];
    [MobClick event:EVENT_ADD_LIST];
    return checkList;
}
@end

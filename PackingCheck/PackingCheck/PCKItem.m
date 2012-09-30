//
//  PCKItem.m
//  PackingCheck
//
//  Created by nanfang on 7/14/12.
//  Copyright (c) 2012 lvtuxiongdi.com. All rights reserved.
//

#import "PCKItem.h"
#import "pinyin.h"
#import "PCKCommon.h"

@implementation PCKItem
@synthesize itemId=_itemId, name=_name;

- (id)initWithId:(int)itemId name:(NSString*)name
{
    self = [super init];
    if (self) {
        self.itemId = itemId;
        self.name = name;
    }
    return self;
    
}

- (id)initWithResultSet:(FMResultSet*)rs
{
    self = [self initWithId:[(NSNumber *)[rs objectForColumnName:@"id"] intValue]  
                       name:[rs objectForColumnName:@"name"]];
    return self;
}

+ (id)ItemWithId:(int)itemId name:(NSString*)name
{
    return [[PCKItem alloc]initWithId:itemId name:name];
    
}

+ (NSMutableArray*) all
{
    return [self find:@"SELECT * FROM item"];
}

+ (PCKItem*)createWithName:(NSString*)name
{
    FMDatabase* db = [PCKCommon database];
    [db executeUpdate:@"INSERT INTO item(name) VALUES (?)", name];
    [MobClick event:EVENT_ADD_ITEM];
    return [[PCKItem alloc]initWithId:[db lastInsertRowId] name:name];
}


+ (PCKItem*)getOrCreateByName:(NSString*)name
{
    NSArray * items = [self find:@"SELECT * FROM item WHERE name = ?", name ];
    if([items count]>0){
        return [items objectAtIndex:0];
    }
    
    return [self createWithName:name];
}

+ (void)removeById:(int)itemId
{
    FMDatabase* db = [PCKCommon database];
    [db beginTransaction];
    [db executeUpdate:@"DELETE FROM list_item WHERE item_id=?", @(itemId)];
    [db executeUpdate:@"DELETE FROM item WHERE id=?", @(itemId)];
    [db commit];
    [MobClick event:EVENT_REMOVE_ITEM];
}


-(NSString*)indexName
{
    char myChar = pinyinFirstLetter([_name characterAtIndex:0]);
    if (myChar == '#'){
        return [[_name substringToIndex:1] uppercaseString];
    }
    return [[NSString stringWithFormat:@"%c" , myChar] uppercaseString];

}

@end

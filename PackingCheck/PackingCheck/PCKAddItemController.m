//
//  PCKAddItemController.m
//  PackingCheck
//
//  Created by nanfang on 8/21/12.
//  Copyright (c) 2012 lvtuxiongdi.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexString.h"
#import "PCKAddItemController.h"
#import "PCKCommon.h"
#import "PCKIndexedItems.h"
#import "PCKItem.h"

#define CHECKED_TAG 99
#define UNCHECKED_TAG 100


@interface PCKAddItemController (){
    UITableView * _tableView;
    UITextField* _newItemField;
    PCKIndexedItems* _indexItems;
    NSMutableArray* _items;
    NSMutableDictionary* _selected;
}

@end

@implementation PCKAddItemController
@synthesize delegate, filterItemIds=_filterItemIds;


- (NSMutableSet*) newItemNames
{
    NSMutableSet* newItemNames = [NSMutableSet set];
    NSString *newItemString = [_newItemField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([newItemString length] > 0){
        newItemString = [newItemString stringByReplacingOccurrencesOfString:@"，" withString:@","];
        [newItemNames addObjectsFromArray:[newItemString componentsSeparatedByString:@","]];
    }
    return newItemNames;
}

- (void) addItems
{
    NSMutableArray * toAddItems = [NSMutableArray array];
    NSMutableSet* newItemNames = [self newItemNames];
    
    for(NSString* itemName in newItemNames){
        [toAddItems addObject:[PCKItem getOrCreateByName:itemName]];
    }
    
    for(PCKItem * item in  [_selected allValues]){
        if(![newItemNames containsObject:item.name]){
            [toAddItems addObject:item];
        }
    }
    
    if([toAddItems count] > 0){
        [delegate addItems:toAddItems];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadItems
{
    _items = [PCKCommon filterItems:[PCKItem all] excludeIds:self.filterItemIds];    
    _indexItems = [[PCKIndexedItems alloc] initWithItems:_items];
    _selected = [NSMutableDictionary dictionary];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"添加宝贝";
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(addItems)] ;
        
        self.navigationItem.rightBarButtonItem = doneButton;

    }
    return self;
}

- (void)dismissKeyboard
{
    if ([_newItemField isFirstResponder]) {
        [_newItemField resignFirstResponder];
    }
}


- (void)loadTableView
{
    _tableView = [[UITableView alloc]init];
    _tableView.backgroundColor = [PCKCommon tableBackground];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.frame = CGRectMake(0, 79, 320, 480-79-20);
    [self.view addSubview:_tableView];
}

- (void)loadTopview
{
    // top view
    UIControl *topView = [[UIControl alloc]init];
    
    topView.backgroundColor = [PCKCommon dottedColor];
    topView.frame = CGRectMake(0, 0, 320, 79);
    
    UILabel * indicatorLabel = [[UILabel alloc]init];
    [topView addSubview:indicatorLabel];
    indicatorLabel.text = @"填入(逗号分隔)或选择几个宝贝:";
    indicatorLabel.font = [PCKCommon bigFont];
    indicatorLabel.textColor = [PCKCommon labelColor];
    indicatorLabel.frame = CGRectMake(15, 11, 300, 14);
    indicatorLabel.backgroundColor = [PCKCommon transparent];
    
    // search bar
    _newItemField = [[UITextField alloc]init];

    _newItemField.frame = CGRectMake(11, 35, 298, 38);
    _newItemField.backgroundColor = [PCKCommon transparent];
    _newItemField.borderStyle = UITextBorderStyleNone;
    _newItemField.layer.borderWidth = 1;
    _newItemField.layer.cornerRadius = 5;
    _newItemField.layer.borderColor = [[PCKCommon borderColor] CGColor];
    _newItemField.backgroundColor = [UIColor whiteColor];    
    _newItemField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    _newItemField.leftViewMode = UITextFieldViewModeAlways;
    _newItemField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;    
    _newItemField.font = [PCKCommon bigFont];
    _newItemField.textColor = [PCKCommon inputColor];

    [topView addSubview:_newItemField];
    [topView addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:topView];    
}

- (void)loadView
{
    [super loadView];
    [self loadTableView];
    [self loadTopview];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setToolbarHidden:YES];
    [self loadItems];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
}

- (PCKItem*)itemForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[_indexItems itemsAtIndexNumber:indexPath.section] objectAtIndex:indexPath.row];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{
    return [_indexItems indexNames];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    int i = [_indexItems indexOfName:title];
    return i>=0? i:0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return [_indexItems.indexNames count] == 0 ? @"" : [_indexItems.indexNames objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_indexItems itemsAtIndexNumber:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_indexItems.indexNames count];
}

- (void)checkCell:(UITableViewCell*)cell withItem:(PCKItem*)item
{
    BOOL checked = [_selected objectForKey:@(item.itemId)] != nil;
    [((UIImageView *)[cell viewWithTag:CHECKED_TAG])setHidden:!checked];
    [((UIImageView *)[cell viewWithTag:UNCHECKED_TAG])setHidden:checked];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PCKItem * item = [self itemForRowAtIndexPath:indexPath];
    
    [_selected objectForKey:@(item.itemId)] != nil? [_selected removeObjectForKey:@(item.itemId)]:[_selected setObject:item forKey:@(item.itemId)];
    [self checkCell:[tableView cellForRowAtIndexPath:indexPath] withItem:item];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCKItem * item = [self itemForRowAtIndexPath:indexPath];
    cell.textLabel.text = item.name;
    [self checkCell:cell withItem:item];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [PCKCommon bigFont];
        cell.textLabel.textColor = [PCKCommon cellLabelColor];
        UIImageView *checkedView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"checked"]];
        UIImageView *uncheckedView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"unchecked"]];
        
        checkedView.frame = CGRectMake(255, 10, 21, 21);
        checkedView.tag = CHECKED_TAG;
        uncheckedView.frame = CGRectMake(255, 10, 21, 21);
        uncheckedView.tag = UNCHECKED_TAG;
        
        [cell addSubview:checkedView];
        [cell addSubview:uncheckedView];
    }
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        // TODO confirm window
        PCKItem * item = [self itemForRowAtIndexPath:indexPath];
        [PCKItem removeById:item.itemId];

        [_indexItems removeAtIndexNumber:indexPath.section row:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


@end

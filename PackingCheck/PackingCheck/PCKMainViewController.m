//
//  PCKViewController.m
//  PackingCheck
//
//  Created by nanfang on 7/7/12.
//  Copyright (c) 2012 lvtuxiongdi.com. All rights reserved.
//

#import "PCKMainViewController.h"
#import "PCKCheckListViewController.h"
#import "PCKAddListController.h"
#import "SEMenuItem.h"
#import "PCKCheckList.h"
#import "JWFolders.h"
#import "UMFeedback.h"
#import "PCKAboutViewController.h"

@interface PCKMainViewController (){
    PCKSpringBoard *_board;
}
@end

@implementation PCKMainViewController
@synthesize configViewController=_configViewController;

- (void) initBoard
{
    NSMutableArray *items = [NSMutableArray array];
    PCKAddListController* addListController = [[PCKAddListController alloc] initWithNibName:nil bundle:nil];
    addListController.delegate = self;
    SEMenuItem *addItem = [SEMenuItem initWithTitle:@"新的行囊" imageName:@"icon_add.png" viewController:addListController removable:YES];
    addItem.isRemovable = NO;
    [items addObject:addItem];
    
    for (PCKCheckList * checkList in [self loadCheckLists]) {
        PCKCheckListViewController *checkListViewController = [[PCKCheckListViewController alloc] initWithNibName:nil bundle:nil];
        checkListViewController.checkList = checkList;
        SEMenuItem *menuItem = [SEMenuItem initWithTitle:[checkList i18nName] imageName:checkList.imageName viewController:checkListViewController removable:YES];
        menuItem.deleteBlock = ^{
            [PCKCheckList removeById:checkList.listId];
        };
        [items addObject:menuItem];
    }
    
    _board = [PCKSpringBoard initWithTitle:@"行囊检查" items:items launcherImage:[UIImage imageNamed:@"navbtn_home.png"]];
    [self.view addSubview:_board];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initBoard];
        self.configViewController = [[PCKConfigViewController alloc] initWithNibName:nil bundle:nil];
        self.configViewController.delegate = self;
    }
    return self;
}

#pragma mark - PCKCheckListDelegate
- (void) addListWithName:(NSString*)name imageName:(NSString*)imageName
{
    PCKCheckListViewController *checkListViewController = [[PCKCheckListViewController alloc] initWithNibName:nil bundle:nil];
    PCKCheckList * newList = [PCKCheckList createWithName:name imageName:imageName];
    checkListViewController.checkList = newList; 
    SEMenuItem *menuItem = [SEMenuItem initWithTitle:newList.name imageName:newList.imageName viewController:checkListViewController removable:YES];
    [_board addMenuItem:menuItem];
}

- (void)startSetting
{
    CGPoint openPoint = CGPointMake(0, 44); //arbitrary point
    [JWFolders openFolderWithContentView:self.configViewController.view
                                position:openPoint 
                           containerView:self.view 
                               openBlock:^(UIView *contentView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction) {
                                   //perform custom animation here on contentView if you wish

                               }
                              closeBlock:^(UIView *contentView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction) {
                                  //also perform custom animation here on contentView if you wish

                              }
                         completionBlock:^ {
                             //the folder is closed and gone, lets do something cool!

                         }
                               direction:JWFoldersOpenDirectionDown
     ];
}

- (void)feedback
{
    [UMFeedback showFeedback:self withAppkey:@"505d25f25270154f50000103"];
}

- (void)about
{
    PCKAboutViewController* about = [[PCKAboutViewController alloc]initWithNibName:nil bundle:nil];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:about];
    [nav viewDidAppear:YES];
    [self presentModalViewController:nav animated:YES];
}


- (NSArray *)loadCheckLists
{
    return [PCKCheckList all];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

}

@end


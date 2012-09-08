//
//  SEMenuItem.h
//  SESpringBoardDemo
//
//  Created by Sarp Erdag on 11/5/11.
//  Copyright (c) 2011 Sarp Erdag. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ItemDeleteBlock)();

@protocol MenuItemDelegate;
@interface SEMenuItem : UIView {
    NSString *image;
    NSString *titleText;
    UIViewController *vcToLoad;
    __weak id<MenuItemDelegate> delegate;
    UIButton *removeButton;
    ItemDeleteBlock deleteBlock;
}

@property (readwrite, copy)ItemDeleteBlock deleteBlock;
@property (nonatomic, assign) int tag;
@property BOOL isRemovable;
@property BOOL isInEditingMode;
@property (weak) id<MenuItemDelegate> delegate;
- (id) initWithTitle:(NSString *)title :(NSString *)imageName :(UIViewController *)viewController :(BOOL)removable;
+ (id) initWithTitle:(NSString *)title imageName:(NSString *)imageName viewController:(UIViewController *)viewController removable:(BOOL)removable;

- (void) enableEditing;
- (void) disableEditing;
- (void) updateTag:(int) newTag;

@end

@protocol MenuItemDelegate <NSObject>
@optional

- (void)launch:(int)index :(UIViewController *)vcToLoad;
- (void)removeFromSpringboard:(int)index;

@end
//
//  SESpringBoard.m
//  SESpringBoardDemo
//
//  Created by Sarp Erdag on 11/5/11.
//  Copyright (c) 2011 Sarp Erdag. All rights reserved.
//

#import "PCKSpringBoard.h"
#import "SEViewController.h"
#import "PCKMainViewController.h"
#import "UIView+FindUIViewController.h"
#import "PCKCheckListViewController.h"

@implementation PCKSpringBoard

@synthesize items, title, launcher, isInEditingMode, itemCounts;

- (IBAction) doneEditingButtonClicked {
    [self disableEditingMode];
}


- (IBAction)settingButtonClicked{
    PCKMainViewController * controller = (PCKMainViewController*)[self firstAvailableUIViewController];
    [controller startSetting];
}

- (void) addMenuItem:(SEMenuItem*)item
{
    [self.items addObject:item];
    [itemsContainer addSubview:item];
    item.tag = [self.items count] - 1;
    item.delegate = self;
    
    int lastPageCount = [(NSNumber*)[self.itemCounts lastObject] intValue];

    
    if (lastPageCount < 12 ) {
        int counter = lastPageCount;
        lastPageCount++;
        [self.itemCounts replaceObjectAtIndex:(pageControl.numberOfPages-1) withObject:[NSNumber numberWithInt:lastPageCount]];
        int horgap = 100 * (counter%3);
        int vergap = 95 * (counter/3);
        
        [item setFrame:CGRectMake(item.frame.origin.x + horgap + ((pageControl.numberOfPages-1)*300), item.frame.origin.y + vergap, 100, 100)];
        
    }else {
        [self.itemCounts addObject:[NSNumber numberWithInt:1]];
        pageControl.numberOfPages++;
        [item setFrame:CGRectMake(item.frame.origin.x + ((pageControl.numberOfPages-1)*300), item.frame.origin.y, 100, 100)];
        [itemsContainer setContentSize:CGSizeMake(pageControl.numberOfPages*300, itemsContainer.frame.size.height)];
    }
    
}

- (void) loadMenuItems
{   
    for (SEMenuItem *item in self.items) {
        [itemsContainer addSubview:item];
    }
    self.itemCounts = [NSMutableArray array];
    [self layoutMenuItems];

}

- (void)layoutMenuItems
{
    int counter = 0;
    int horgap = 0;
    int vergap = 0;
    int numberOfPages = (ceil((float)[self.items count] / 12));
    
    int currentPage = 0;
    for (SEMenuItem *item in self.items) {
        currentPage = counter / 12;
        item.tag = counter;
        item.delegate = self;
        [item setFrame:CGRectMake(item.frame.origin.x + horgap + (currentPage*300), item.frame.origin.y + vergap, 100, 100)];
        
        horgap = horgap + 100;
        counter = counter + 1;
        if(counter % 3 == 0){
            vergap = vergap + 95;
            horgap = 0;
        }
        if (counter % 12 == 0) {
            vergap = 0;
        }
    }
    
    // record the item counts for each page
    
    
    
    int totalNumberOfItems = [self.items count];
    int numberOfFullPages = totalNumberOfItems/12;
    int lastPageItemCount = totalNumberOfItems - numberOfFullPages*12;
    for (int i=0; i<numberOfFullPages; i++)
        [self.itemCounts addObject:[NSNumber numberWithInteger:12]];
    if (lastPageItemCount != 0)
        [self.itemCounts addObject:[NSNumber numberWithInteger:lastPageItemCount]];
    
    [itemsContainer setContentSize:CGSizeMake(numberOfPages*300, itemsContainer.frame.size.height)];
    if (numberOfPages > 1) {
        pageControl.numberOfPages = numberOfPages;

    }
}



- (id) initWithTitle:(NSString *)boardTitle items:(NSMutableArray *)menuItems image:(UIImage *) image{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 460)];
    [self setUserInteractionEnabled:YES];
    if (self) {
        self.launcher = image;
        self.isInEditingMode = NO;
        
        // create the top bar
        self.title = boardTitle;
        navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        navigationBar.barStyle = UIBarStyleBlack;
        [navigationBar pushNavigationItem:[[UINavigationItem alloc]init] animated:NO];
        navigationBar.topItem.title = self.title;

        navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                  target:self
                                                                                  action:@selector (settingButtonClicked)];
        

        doneEditingButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                                   style:UIBarButtonItemStylePlain
                                                                                  target:self
                                                                                  action:@selector (doneEditingButtonClicked)];
        
        
        [self addSubview:navigationBar];
        
        // create a container view to put the menu items inside
        itemsContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 50, 300, 400)];
        itemsContainer.delegate = self;
        [itemsContainer setScrollEnabled:YES];
        [itemsContainer setPagingEnabled:YES];
        itemsContainer.showsHorizontalScrollIndicator = NO;
        [self addSubview:itemsContainer];
        // add a page control representing the page the scrollview controls
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 433, 320, 20)];
        
        self.items = menuItems;
        [self loadMenuItems];
        
        // TODO add page view according to page number counting from loadItemMenus
        [self addSubview:pageControl];
        
        // add listener to detect close view events
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(closeViewEventHandler:)
         name:@"closeView"
         object:nil ];
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    }
    return self;
}

+ (id) initWithTitle:(NSString *)boardTitle items:(NSMutableArray *)menuItems launcherImage:(UIImage *)image {
    PCKSpringBoard *tmpInstance = [[PCKSpringBoard alloc] initWithTitle:boardTitle items:menuItems image:image];
	return tmpInstance;
};


// transition animation function required for the springboard look & feel
- (CGAffineTransform)offscreenQuadrantTransformForView:(UIView *)theView {
    CGPoint parentMidpoint = CGPointMake(CGRectGetMidX(theView.superview.bounds), CGRectGetMidY(theView.superview.bounds));
    CGFloat xSign = (theView.center.x < parentMidpoint.x) ? -1.f : 1.f;
    CGFloat ySign = (theView.center.y < parentMidpoint.y) ? -1.f : 1.f;
    return CGAffineTransformMakeTranslation(xSign * parentMidpoint.x, ySign * parentMidpoint.y);
}

#pragma mark - MenuItem Delegate Methods

- (void)launch:(int)tag :viewController {
    
    // if the springboard is in editing mode, do not launch any view controller
    if (isInEditingMode)
        return;
    
    // first disable the editing mode so that items will stop wiggling when an item is launched
    [self disableEditingMode];
    
    // TODO increase clicks for the list
    
    if([viewController isKindOfClass:[PCKCheckListViewController class]]){
        [viewController increaseOpens];
    }
        
    // create a navigation bar
    nav = [UINavigationController alloc];
    SEViewController *vc = viewController;
    
    // manually trigger the appear method
    [viewController viewDidAppear:YES];
    
    vc.launcherImage = launcher;
    nav = [nav initWithRootViewController:viewController];
    [nav viewDidAppear:YES];
    
    nav.view.alpha = 0.f;
    nav.view.transform = CGAffineTransformMakeScale(.1f, .1f);
    [self addSubview:nav.view];
    
    [UIView animateWithDuration:.3f  animations:^{
        // fade out the buttons
        for(SEMenuItem *item in self.items) {
            item.transform = [self offscreenQuadrantTransformForView:item];
            item.alpha = 0.f;
        }
        
        // fade in the selected view
        nav.view.alpha = 1.f;
        nav.view.transform = CGAffineTransformIdentity;
        [nav.view setFrame:CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height)];
        
        // fade out the top bar
        [navigationBar setFrame:CGRectMake(0, -44, 320, 44)];
    }];
}

- (void)removeFromSpringboard:(int)index {
    
    // Remove the selected menu item from the springboard, it will have a animation while disappearing
    SEMenuItem *menuItem = [items objectAtIndex:index];
    [menuItem removeFromSuperview];
    
    int numberOfItemsInCurrentPage = [[self.itemCounts objectAtIndex:pageControl.currentPage] intValue];
    
    // First find the index of the current item with respect of the current page
    // so that only the items coming after the current item will be repositioned.
    // The index of the item can be found by looking at its coordinates
    int mult = ((int)menuItem.frame.origin.y) / 95;
    int add = ((int)menuItem.frame.origin.x % 300)/100;
    int pageSpecificIndex = (mult*3) + add;
    int remainingNumberOfItemsInPage = numberOfItemsInCurrentPage-pageSpecificIndex;    
    
    // Select the items listed after the deleted menu item
    // and move each of the ones on the current page, one step back.
    // The first item of each row becomes the last item of the previous row.
    for (int i = index+1; i<[items count]; i++) {
        SEMenuItem *item = [items objectAtIndex:i];   
        [UIView animateWithDuration:0.2 animations:^{
            
            // Only reposition the items in the current page, coming after the current item
            if (i < index + remainingNumberOfItemsInPage) {
                
                int intVal = item.frame.origin.x;
                // Check if it is the first item in the row
                if (intVal % 3 == 0)
                    [item setFrame:CGRectMake(item.frame.origin.x+200, item.frame.origin.y-95, item.frame.size.width, item.frame.size.height)];
                else 
                    [item setFrame:CGRectMake(item.frame.origin.x-100, item.frame.origin.y, item.frame.size.width, item.frame.size.height)];
            }            
            
            // Update the tag to match with the index. Since the an item is being removed from the array, 
            // all the items' tags coming after the current item has to be decreased by 1.
            [item updateTag:item.tag-1];
        }]; 
    }
    // remove the item from the array of items
    [items removeObjectAtIndex:index];
    // also decrease the record of the count of items on the current page and save it in the array holding the data
    numberOfItemsInCurrentPage--;
    [self.itemCounts replaceObjectAtIndex:pageControl.currentPage withObject:[NSNumber numberWithInteger:numberOfItemsInCurrentPage]];
}

- (void)closeViewEventHandler: (NSNotification *) notification {
    UIView *viewToRemove = (UIView *) notification.object;    
    [UIView animateWithDuration:.3f animations:^{
        viewToRemove.alpha = 0.f;
        viewToRemove.transform = CGAffineTransformMakeScale(.1f, .1f);
        for(SEMenuItem *item in self.items) {
            item.transform = CGAffineTransformIdentity;
            item.alpha = 1.f;
        }
        [navigationBar setFrame:CGRectMake(0, 0, 320, 44)];
    } completion:^(BOOL finished) {
        [viewToRemove removeFromSuperview];
    }];
    
    // release the dynamically created navigation bar
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)sender {

    CGFloat pageWidth = itemsContainer.frame.size.width;
    int page = floor((itemsContainer.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}


#pragma mark - Custom Methods

- (void) disableEditingMode {
    // loop thu all the items of the board and disable each's editing mode
    for (SEMenuItem *item in items)
        [item disableEditing];
    
    navigationBar.topItem.rightBarButtonItem = nil;
    self.isInEditingMode = NO;
}

- (void) enableEditingMode {
    
    for (SEMenuItem *item in items)
        [item enableEditing];
    
    // show the done editing button
    navigationBar.topItem.rightBarButtonItem = doneEditingButton;
    self.isInEditingMode = YES;
}

@end

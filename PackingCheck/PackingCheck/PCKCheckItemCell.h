#import <UIKit/UIKit.h>
#import "TDBadgedCell.h"
#import "PCKItem.h"

@class PCKCheckItemCell;

typedef enum {
	PCKCheckItemCellDirectionRight = 0,
	PCKCheckItemCellDirectionLeft,
	PCKCheckItemCellDirectionBoth,
	PCKCheckItemCellDirectionNone,
} PCKCheckItemCellDirection;

@protocol PCKCheckItemCellSlideDelegate <NSObject>

@optional
- (void)cellDidHide:(PCKCheckItemCell *)cell;
- (void)cellDidUnhide:(PCKCheckItemCell *)cell;
@end

@interface PCKCheckItemCell : UITableViewCell

// item
@property(nonatomic,strong) PCKItem * item;

// slide
@property BOOL hide;
@property (weak) id <PCKCheckItemCellSlideDelegate> delegate;
@property (nonatomic, assign) PCKCheckItemCellDirection direction;
@property BOOL shouldBounce;

// badge
@property (nonatomic, strong)   NSString *badgeString;
@property (nonatomic, strong)   TDBadgeView *badge;
@property (nonatomic, strong)   UIColor *badgeColor;
@property (nonatomic, strong)   UIColor *badgeColorHighlighted;
@property BOOL showShadow;

//-(void)showSweep;
@end

#import <UIKit/UIKit.h>
#import "SEViewController.h"
#import "PCKCheckList.h"
#import "PCKCheckItemCell.h"
#import "DACircularProgressView.h"
#import "PCKAddItemController.h"
#import "MBProgressHUD.h"
@interface PCKCheckListViewController : SEViewController<UITableViewDataSource, UITableViewDelegate, PCKCheckItemCellSlideDelegate, PCKAddItemDelegate, MBProgressHUDDelegate> {
}

- (void)increaseOpens;
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) PCKCheckList* checkList;
@property(strong, nonatomic) DACircularProgressView* progressView;
@end

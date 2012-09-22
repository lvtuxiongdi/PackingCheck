#import "PCKCheckListViewController.h"
#import "TDBadgedCell.h"
#import "PCKCheckItemCell.h"
#import "PCKItem.h"
#import "PCKBuyButton.h"
#import "PCKCommon.h"
#import "UIGlossyButton.h"
#import "UIView+LayerEffects.h"

@interface PCKCheckListViewController(){
    NSMutableSet * _checkedItems;
    NSMutableArray* _items;
    NSMutableSet * _itemIds;
    BOOL _isChecking;
    BOOL _isEditing;

    MBProgressHUD* _hud;

    UIGlossyButton *_resetButton;
    
}
@end
@implementation PCKCheckListViewController
@synthesize checkList=_checkList, tableView=_tableView, progressView=_progressView;



- (void) loadItems
{
    _items = [_checkList items];
    _itemIds = [NSMutableSet set];
    for(PCKItem* item in _items){
        [_itemIds addObject:@(item.itemId)];
    }
    _checkedItems = [NSMutableSet set];
}

-(void)addItems:(NSArray*)items
{
    [self.checkList addItems:[PCKCommon filterItems:items excludeIds:_itemIds]];
    [self loadItems];
    [self.tableView reloadData];
}


- (void)increaseOpens
{
    [self.checkList increaseOpens];    
}

- (void)addItemLaunch
{
    PCKAddItemController * addItemController = [[PCKAddItemController alloc] initWithNibName:nil bundle:nil];
    
    addItemController.delegate = self;
    addItemController.filterItemIds = _itemIds;
    [self.navigationController pushViewController:addItemController animated:YES];
}

- (void)switchEdit
{
    _isEditing = !_isEditing;
    [self.tableView setEditing:_isEditing animated:YES];
}

- (void)stopChecking
{
    _isChecking = NO;
    [_checkedItems removeAllObjects];
    for (UIBarButtonItem * button in self.navigationItem.rightBarButtonItems){
        button.enabled = YES;
    }
    
    [self.tableView reloadData];
}

- (void)startChecking
{
    if (_isEditing) {
        [self switchEdit];
    }
    
    _isChecking = YES;
    for (UIBarButtonItem * button in self.navigationItem.rightBarButtonItems){
        button.enabled = NO;
    }
    
    [self.tableView reloadData];
}


- (void)checkSwitch: (id)sender
{
    // TODO Very dirty, think of a better way 
    if(_isChecking){
        if(_resetButton.titleLabel.text == @"滑动搞定的宝贝"){
            [_resetButton setTitle:@"结束检查" forState:UIControlStateNormal];
        }else{
            [self stopChecking];
            [self.progressView setHidden:YES];
            self.progressView.progress = 0.0;
            [_resetButton setTitle:@"开始检查" forState:UIControlStateNormal];
            _resetButton.tintColor = [UIColor brownColor];
        }
    }else{
        [self startChecking];
        [self.progressView setHidden:NO];
        [_resetButton setTitle:@"滑动搞定的宝贝" forState:UIControlStateNormal];
        _resetButton.tintColor = [UIColor blueColor];
    }
}

- (void)loadToolBar
{
    CGRect tvFrame = self.view.bounds;
    UIView * toolbar = [[UIView alloc]initWithFrame:CGRectMake(0, tvFrame.size.height - 100, tvFrame.size.width, 100)];
    toolbar.backgroundColor = [UIColor blackColor];
    
    
    [self.view addSubview:toolbar];
    
    _resetButton = [[UIGlossyButton alloc]initWithFrame:CGRectMake(80.0, 10.0, 160.0, 40.0)];
    [_resetButton addTarget:self action:@selector(checkSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [_resetButton setTitle:@"开始检查" forState:UIControlStateNormal];
    [_resetButton useWhiteLabel: YES];
    _resetButton.tintColor = [UIColor brownColor];
	[_resetButton setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
    [_resetButton setGradientType:kUIGlossyButtonGradientTypeLinearSmoothBrightToNormal];
    
    [_resetButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    _resetButton.titleLabel.textColor = [UIColor colorWithWhite:0.902 alpha:1.000];
//    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
//    self.titleLabel.textColor = [UIColor colorWithWhite:0.902 alpha:1.000];
//    [_resetButton setTitle:@"滑动搞定的宝贝" forState:UIControlStateSelected];

//	[_resetButton setBuyBlock:^(void){
//        NSLog(@"buy");
//    }];
    
    [toolbar addSubview:_resetButton];

    
    self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(260.0f, 10.0f, 36.0f, 36.0f)];
    [self.progressView setHidden:YES];
    [toolbar addSubview:self.progressView];
}

- (void)loadItemTable
{
    CGRect tvFrame = self.view.bounds;
    tvFrame.size = CGSizeMake(tvFrame.size.width, tvFrame.size.height - 100);
    self.tableView = [[UITableView alloc] initWithFrame:tvFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [PCKCommon tableBackground];
    [self.view addSubview:self.tableView];

}

- (void)loadNavBar
{
    self.title = self.checkList.name;
    
    UIBarButtonItem *addLauncher = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target: self
                                                                                 action: @selector (addItemLaunch)];
    UIBarButtonItem *editLauncher = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                  target: self
                                                                                  action: @selector (switchEdit)];    
    self.navigationItem.rightBarButtonItems = @[editLauncher,addLauncher];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isChecking = NO;
        _isEditing = NO;
    }
    return self;
}

- (void)loadHud
{
    _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.delegate = self;
    [self.navigationController.view addSubview:_hud];
}

- (void)loadView
{
    [super loadView];
    [self loadToolBar];
    [self loadItemTable];
    [self loadNavBar];
    [self loadItems];
    [self loadHud];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // place any dynamic stuff you want to initialize in the child view here
//    [self.navigationController.toolbar addSubview:self.progressView];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    self.navigationController.toolbar.tintColor = [UIColor blackColor];
    
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController setToolbarHidden:NO];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PCKCheckListCell";
    PCKCheckItemCell *cell = (PCKCheckItemCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PCKCheckItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont boldSystemFontOfSize: 18];
        [cell.textLabel setShadowOffset:CGSizeMake(0.0, -0.6)];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.badgeColorHighlighted = [UIColor whiteColor];
        cell.delegate = self;
    }

    cell.badgeString = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    cell.badgeColor = indexPath.row < 3? [UIColor redColor]:[UIColor colorWithRed:0.530f green:0.600f blue:0.738f alpha:1.000f];
    
    PCKItem * item = [_items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    cell.item = item;
    cell.hide = [_checkedItems containsObject:[NSNumber numberWithInt:item.itemId]];
    
    if (_isChecking){
        cell.direction = PCKCheckItemCellDirectionBoth;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sliced_bg_green"]];
        cell.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noise"]];
    }else {
        cell.direction = PCKCheckItemCellDirectionNone;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.contentView.backgroundColor = [PCKCommon tableBackground];
        cell.backgroundView.backgroundColor = [PCKCommon tableBackground];;
    }

    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return !_isChecking && _isEditing;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    int fromRow = [sourceIndexPath row];
    int toRow = [destinationIndexPath row];
    PCKItem * item = [_items objectAtIndex:fromRow];
    [_items removeObjectAtIndex:fromRow];
    [_items insertObject:item atIndex:toRow];
    [_checkList reorderItems:_items];
    [self.tableView reloadData];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        int row = [indexPath row];
        PCKItem * item = [_items objectAtIndex:indexPath.row];
        
        [_checkList removeItemWithId:item.itemId];
        [_items removeObjectAtIndex:row];
        [_itemIds removeObject:@(item.itemId)];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)updateProgress
{
    if (_items && [_items count]>0){
        self.progressView.progress = [_checkedItems count] == [_items count]? 0.99 : [_checkedItems count]/(float)[_items count];
        
        if([_checkedItems count] == [_items count]){
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            _hud.labelText = @"全部搞定！出发吧！";
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
    }
    
}

#pragma PCKCheckItemCellSlideDelegate
- (void)cellDidHide:(PCKCheckItemCell *)cell
{
    [_checkedItems addObject:[NSNumber numberWithInt:cell.item.itemId]];
    [self updateProgress];
    // TODO Very dirty, think of a better way
    if(_resetButton.titleLabel.text == @"滑动搞定的宝贝"){
        [_resetButton setTitle:@"结束检查" forState:UIControlStateNormal];
    }
}

- (void)cellDidUnhide:(PCKCheckItemCell *)cell
{
    [_checkedItems removeObject:[NSNumber numberWithInt:cell.item.itemId]];
    [self updateProgress];
}


@end

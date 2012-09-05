#import "PCKCheckListViewController.h"
#import "TDBadgedCell.h"
#import "PCKCheckItemCell.h"
#import "PCKItem.h"
#import "PCKBuyButton.h"
#import "PCKCommon.h"

@interface PCKCheckListViewController(){
    NSMutableSet * _checkedItems;
    NSMutableArray* _items;
    NSMutableSet * _itemIds;
    BOOL _isChecking;
    BOOL _isEditing;
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
    if(_isChecking){
        [self stopChecking];
        [self.progressView setHidden:YES];
        self.progressView.progress = 0.0;
    }else{
        [self startChecking];
        [self.progressView setHidden:NO];
    }
    
}

- (void)loadToolBar
{
    
    CGRect tvFrame = self.view.bounds;
    UIView * toolbar = [[UIView alloc]initWithFrame:CGRectMake(0, tvFrame.size.height - 100, tvFrame.size.width, 100)];
    toolbar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:toolbar];
    
    PCKBuyButton *resetButton = [[PCKBuyButton alloc]initWithFrame:CGRectMake(100.0, 10.0, 120.0, 40.0)];
    [resetButton addTarget:self action:@selector(checkSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [resetButton setTitle:@"     开始检查     " forState:UIControlStateNormal];
    [resetButton setTitle:@"滑动搞定的宝贝" forState:UIControlStateSelected];

	[resetButton setBuyBlock:^(void){
        NSLog(@"buy");
    }];
    
    [toolbar addSubview:resetButton];

    
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


- (void)loadView
{
    [super loadView];
    [self loadToolBar];
    [self loadItemTable];
    [self loadNavBar];
    [self loadItems];
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


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
//    NSInteger fromRow = [sourceIndexPath row];
//    NSInteger toRow = [destinationIndexPath row];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        int row = [indexPath row];
        PCKItem * item = [_items objectAtIndex:indexPath.row];
        
        [_checkList removeItemWithId:item.itemId];
        [_items removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)updateProgress
{
    if (_items && [_items count]>0){
        self.progressView.progress = [_checkedItems count] == [_items count]? 0.99 : [_checkedItems count]/(float)[_items count];
    }
}

#pragma PCKCheckItemCellSlideDelegate
- (void)cellDidHide:(PCKCheckItemCell *)cell
{
    [_checkedItems addObject:[NSNumber numberWithInt:cell.item.itemId]];
    [self updateProgress];    
}

- (void)cellDidUnhide:(PCKCheckItemCell *)cell
{
    [_checkedItems removeObject:[NSNumber numberWithInt:cell.item.itemId]];
    [self updateProgress];
}


@end

#import "PCKCheckListViewController.h"
#import "TDBadgedCell.h"
#import "PCKCheckItemCell.h"
#import "PCKItem.h"
#import "PCKBuyButton.h"
#import "PCKAddItemController.h"
#import "PCKCommon.h"

@interface PCKCheckListViewController(){
    NSMutableSet * _checkedItems;
    NSMutableArray* _items;
    BOOL _isChecking;
}
@end
@implementation PCKCheckListViewController
@synthesize checkList=_checkList, tableView=_tableView, progressView=_progressView;


- (void) loadItems
{
    
    _items = [_checkList items];
    _checkedItems = [NSMutableSet set];
}


- (void)increaseOpens
{
    [self.checkList increaseOpens];    
}

- (void)addItem: (id)sender
{
    PCKAddItemController * addItemController = [[PCKAddItemController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:addItemController animated:YES];
}

- (void)editItems: (id)sender
{
    NSLog(@"TODO edit");    
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
    }else{
        [self startChecking];
    }
    
}

- (void)loadToolBar
{
    
    CGRect tvFrame = self.view.bounds;
    UIView * toolbar = [[UIView alloc]initWithFrame:CGRectMake(0, tvFrame.size.height - 100, tvFrame.size.width, 100)];
    toolbar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:toolbar];
    
    PCKBuyButton *resetButton = [[PCKBuyButton alloc]initWithFrame:CGRectMake(100.0, 10.0, 70.0, 30.0)];
    [resetButton addTarget:self action:@selector(checkSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [resetButton setTitle:@"开始检查" forState:UIControlStateNormal];
    [resetButton setTitle:@"结束检查" forState:UIControlStateSelected];

	[resetButton setBuyBlock:^(void){
        NSLog(@"buy");
    }];
    
    [toolbar addSubview:resetButton];
    
    self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(260.0f, 4.0f, 36.0f, 36.0f)];
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
    [self loadItems];
}

- (void)loadNavBar
{
    self.title = self.checkList.name;
    
    UIBarButtonItem *addLauncher = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target: self
                                                                                 action: @selector (addItem:)];
    UIBarButtonItem *editLauncher = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                  target: self
                                                                                  action: @selector (editItems:)];    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: editLauncher,addLauncher, nil];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isChecking = NO;
    }
    return self;
}


- (void)loadView
{
    [super loadView];
    [self loadToolBar];
    [self loadItemTable];
    [self loadNavBar];

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

        cell.textLabel.font = [UIFont boldSystemFontOfSize: 18];

        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.badgeColorHighlighted = [UIColor whiteColor];
        cell.delegate = self;
    }

    cell.badgeString = [NSString stringWithFormat:@"%d", indexPath.row + 1];

    if(indexPath.row < 3){
        cell.badgeColor = [UIColor redColor];
    }else {
        cell.badgeColor = [UIColor colorWithRed:0.530f green:0.600f blue:0.738f alpha:1.000f];
    }
    
    PCKItem * item = [_items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    cell.item = item;
    cell.hide = NO;

    
    if ([_checkedItems containsObject:[NSNumber numberWithInt:item.itemId]]){
        cell.hide = YES;
    }
    
    if (_isChecking){
        cell.direction = PCKCheckItemCellDirectionBoth;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sliced_bg_green"]];
    }else {
        cell.direction = PCKCheckItemCellDirectionNone;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.contentView.backgroundColor = [PCKCommon tableBackground];
    }

    return cell;

}

#pragma PCKCheckItemCellSlideDelegate
- (void)cellDidHide:(PCKCheckItemCell *)cell
{
    [_checkedItems addObject:[NSNumber numberWithInt:cell.item.itemId]];
    // TODO compute right number
    self.progressView.progress += 0.03f;
}

- (void)cellDidUnhide:(PCKCheckItemCell *)cell
{
    [_checkedItems removeObject:[NSNumber numberWithInt:cell.item.itemId]];
    self.progressView.progress -= 0.03f;
}


@end

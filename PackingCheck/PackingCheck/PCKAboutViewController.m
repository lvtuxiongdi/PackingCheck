//
//  PCKAbountViewController.m
//  PackingCheck
//
//  Created by nanfang on 9/22/12.
//  Copyright (c) 2012 lvtuxiongdi.com. All rights reserved.
//

#import "PCKAboutViewController.h"
#import "PCKCommon.h"
@interface PCKAboutViewController ()

@end

@implementation PCKAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"关于我们";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *exitButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(exit)];
	self.navigationItem.leftBarButtonItem = exitButton;
    self.view.backgroundColor = [PCKCommon smallBackgroundColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(32, 40, 256, 128)];
    imageView.image = [UIImage imageNamed:@"about"];
    [self.view addSubview:imageView];
    
    UILabel * h1 = [[UILabel alloc]initWithFrame:CGRectMake(80, 200, 150, 36)];
    h1.text = @"行囊检查";
    h1.textColor = [UIColor whiteColor];
    h1.font = [UIFont boldSystemFontOfSize:36];
    h1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:h1];
    
    UILabel * h2 = [[UILabel alloc]initWithFrame:CGRectMake(40, 250, 280, 20)];
    h2.text = @"旅途兄弟出品 lvtuxiongdi.com";
    h2.textColor = [UIColor whiteColor];
    h2.font = [UIFont systemFontOfSize:18];
    h2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:h2];
    
    UILabel * version = [[UILabel alloc]initWithFrame:CGRectMake(230, 220, 50, 16)];
    // TODO read verison number from config
    version.text = @"v1.0";
    version.textColor = [UIColor whiteColor];
    version.font = [UIFont systemFontOfSize:16];
    version.backgroundColor = [UIColor clearColor];
    [self.view addSubview:version];

}

- (void)exit
{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

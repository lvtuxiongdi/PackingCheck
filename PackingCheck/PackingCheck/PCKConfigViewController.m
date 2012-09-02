//
//  PCKConfigFolderViewController.m
//  PackingCheck
//
//  Created by nanfang on 7/12/12.
//  Copyright (c) 2012 lvtuxiongdi.com. All rights reserved.
//

#import "PCKConfigViewController.h"
#import "PCKCommon.h"

@interface PCKConfigViewController ()

@end

@implementation PCKConfigViewController
@synthesize itemsButton=_itemsButton, createListButton=_createListButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (UIGlossyButton*) controlButtonWithTitle:(NSString*)title frame:(CGRect)frame
{
    UIGlossyButton* controlButton = [[UIGlossyButton alloc]init];
    controlButton.tintColor = [UIColor blueColor];
	[controlButton useWhiteLabel: YES];
	controlButton.innerBorderWidth = 0.0f;
	controlButton.buttonBorderWidth = 1.0f;
	controlButton.buttonCornerRadius = 0.0f;
	[controlButton setGradientType: kUIGlossyButtonGradientTypeLinearSmoothStandard];
	[controlButton setExtraShadingType:kUIGlossyButtonExtraShadingTypeAngleRight];
	controlButton.backgroundOpacity  =0.75;
    controlButton.titleLabel.font = [UIFont systemFontOfSize:12];
    controlButton.frame = frame;
    [controlButton setTitle:title forState:UIControlStateNormal];
    return controlButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg1"]];
    self.view.frame = CGRectMake(0, 0, 320, 120);
    
    self.createListButton = [self controlButtonWithTitle:@"关于" frame:CGRectMake(20, 20, 70,70)];
    self.itemsButton = [self controlButtonWithTitle:@"反馈" frame:CGRectMake(110, 20, 70,70)];
    
    [self.view addSubview:self.createListButton];    
    [self.view addSubview:self.itemsButton];
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

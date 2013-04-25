//
//  PCKConfigFolderViewController.m
//  PackingCheck
//
//  Created by nanfang on 7/12/12.
//  Copyright (c) 2012 lvtuxiongdi.com. All rights reserved.
//

#import "PCKConfigViewController.h"
#import "PCKCommon.h"
#import "UMFeedback.h"
#import "IMAdView.h"

@interface PCKConfigViewController ()

@end

@implementation PCKConfigViewController

@synthesize delegate,feedbackButton=_feedbackButton, aboutButton=_aboutButton;

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
    self.view.frame = CGRectMake(0, 0, 320, 220);
    self.feedbackButton = [self controlButtonWithTitle:@"反馈" frame:CGRectMake(20, 20, 70, 70)];
    [self.feedbackButton addTarget:self action:@selector(feedback) forControlEvents:UIControlEventTouchUpInside];
    
    self.aboutButton = [self controlButtonWithTitle:@"关于" frame:CGRectMake(110, 20, 70, 70)];
    [self.aboutButton addTarget:self action:@selector(about) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.aboutButton];
    [self.view addSubview:self.feedbackButton];
    
    // integrate InMobi Ad
    IMAdView *imAdView = [[IMAdView alloc] initWithFrame:CGRectMake(0, 130, 320, 50) imAppId:@"da59f9d22af844f78c94ee70008ed30f"
                           imAdSize:IM_UNIT_320x50];

    IMAdRequest *request = [IMAdRequest request];
    [imAdView loadIMAdRequest:request];
    imAdView.refreshInterval = 30;
    [self.view addSubview:imAdView];
	// Do any additional setup after loading the view.
}

- (void)feedback
{
    [self.delegate feedback];
}

- (void)about
{
    [self.delegate about];
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

//
//  GFZMainViewController.m
//  Gluten Free Zone
//
//  Created by P & C on 3/22/13.
//  Copyright (c) 2013 P & C. All rights reserved.
//

#import "GFZMainViewController.h"

@interface GFZMainViewController ()

@end

@implementation GFZMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
/*    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"Scan a product!";
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOut)];
    self.navigationItem.rightBarButtonItem = signOutButton;
 
 */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

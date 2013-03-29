//
//  GFZCreateAccountViewController.m
//  Gluten Free Zone
//
//  Created by P & C on 3/20/13.
//  Copyright (c) 2013 P & C. All rights reserved.
//

#import "GFZCreateAccountViewController.h"

@interface GFZCreateAccountViewController ()

@end

@implementation GFZCreateAccountViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

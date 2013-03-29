//
//  GFZScanViewController.m
//  Gluten Free Zone
//
//  Created by P & C on 3/20/13.
//  Copyright (c) 2013 P & C. All rights reserved.
//

#import "GFZScanViewController.h"
#import "ScanditSDKBarcodePicker.h"

@interface GFZScanViewController ()

@end

@implementation GFZScanViewController

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
    NSLog(@"Hello Scan Controller");
    _picker = [[ScanditSDKBarcodePicker alloc] initWithAppKey:@"W0ckOpMPEeKbT6Dw0U38q9nrbZiC29atMDBs8JjjKmk"];
    _navController = [[UINavigationController alloc] initWithRootViewController:_picker];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelScan)];
    _picker.navigationItem.rightBarButtonItem = anotherButton;
    UINavigationBar *bar = [_picker.navigationController navigationBar];
    [bar setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scanditSDKOverlayController:
(ScanditSDKOverlayController *)scanditSDKOverlayController
                     didScanBarcode:(NSDictionary *)barcodeResult {
    NSLog(@"Got a barcode: %@\n", [barcodeResult objectForKey:@"barcode"]);
    [_picker stopScanning];
    [self dismissModalViewControllerAnimated: YES];
    [self getScanResult: [barcodeResult objectForKey:@"barcode"]];
}

- (void)scanditSDKOverlayController:
(ScanditSDKOverlayController *)scanditSDKOverlayController
                didCancelWithStatus:(NSDictionary *)status {}

- (void)scanditSDKOverlayController:
(ScanditSDKOverlayController *)scanditSDKOverlayController
                    didManualSearch:(NSString *)input {}

- (void) cancelScan {
    [self dismissModalViewControllerAnimated: YES];
}


- (IBAction)NewScanButton:(id)sender {
    _picker.overlayController.delegate = self;
    [_picker startScanning];
    [self presentModalViewController:_navController animated:YES];
}


- (void)viewDidUnload {
    [self setScanResultImage:nil];
    [self setScanResultText:nil];
    [self setResultsLabel:nil];
    [self setNewScanButtonProperty:nil];
    [super viewDidUnload];
}

- (void)showSafeResult {
    UIImage *buttonImage = [UIImage imageNamed: @"new-scan.png"];
    [self.NewScanButtonProperty setImage:buttonImage forState: UIControlStateNormal];
    UIImage *image = [UIImage imageNamed: @"check.png"];
    self.ScanResultImage.image = image;
    self.ScanResultText.text = @"This product is";
    self.ScanResultText.hidden = NO;
    self.ResultsLabel.text = @"gluten free!";
    self.ResultsLabel.hidden = NO;
}

- (void)showNotSafeResult {
    UIImage *buttonImage = [UIImage imageNamed: @"new-scan-red.png"];
    [self.NewScanButtonProperty setImage:buttonImage forState: UIControlStateNormal];
    UIImage *image = [UIImage imageNamed: @"x.png"];
    self.ScanResultImage.image = image;
    self.ScanResultText.text = @"This product is";
    self.ScanResultText.hidden = NO;
    self.ResultsLabel.text = @"not gluten free!";
    self.ResultsLabel.hidden = NO;
}

- (void)showNoResult {
    UIImage *buttonImage = [UIImage imageNamed: @"new-scan-red.png"];
    [self.NewScanButtonProperty setImage:buttonImage forState: UIControlStateNormal];
    UIImage *image = [UIImage imageNamed: @"Question-Mark.jpg"];
    self.ScanResultImage.image = image;
    self.ScanResultText.text = @"Oops!";
    self.ScanResultText.hidden = NO;
    self.ResultsLabel.text = @"No results";
    self.ResultsLabel.hidden = NO;
}

-(void)getScanResult: (NSString *) barcode {
    NSLog(@"testing barcode: %@", barcode);
    //process the barcod here
    if([barcode isEqualToString: @"718122850617"]){
    //show result
        [self showSafeResult];
    }else if([barcode isEqualToString: @"639382000393"]){
        
        [self showNotSafeResult];
    }else{
        [self showNoResult];
    }
}
- (IBAction)SignOutButton:(id)sender {
    NSLog(@"sign out");
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end

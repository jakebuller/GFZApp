//
//  GFZScanViewController.m
//  Gluten Free Zone
//
//  Created by P & C on 3/20/13.
//  Copyright (c) 2013 P & C. All rights reserved.
//

#import "GFZScanViewController.h"
#import "ScanditSDKBarcodePicker.h"
#import "Reachability.h"

@interface GFZScanViewController (){
    Reachability *internetReachableFoo;
}

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
    [self testInternetConnection];
    NSLog(@"Hello Scan Controller");
    _picker = [[ScanditSDKBarcodePicker alloc] initWithAppKey:@"W0ckOpMPEeKbT6Dw0U38q9nrbZiC29atMDBs8JjjKmk"];
    _navController = [[UINavigationController alloc] initWithRootViewController:_picker];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelScan)];
    _picker.navigationItem.rightBarButtonItem = anotherButton;
    UINavigationBar *bar = [_picker.navigationController navigationBar];
    [bar setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
    self.data = [[NSMutableData alloc] initWithCapacity: 1024];
    
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
    [self hideCurrentResult];
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
    self.ScanResultImage.hidden = NO;   
    UIImage *buttonImage = [UIImage imageNamed: @"new-scan.png"];
    [self.NewScanButtonProperty setImage:buttonImage forState: UIControlStateNormal];
    UIImage *image = [UIImage imageNamed: @"check.png"];
    self.ScanResultImage.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        self.ScanResultImage.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    self.ScanResultImage.image = image;
    self.ScanResultText.text = @"This product is";
    self.ScanResultText.hidden = NO;
    self.ResultsLabel.text = @"gluten free!";
    self.ResultsLabel.hidden = NO;
    self.NewScanButtonProperty.hidden = NO;
}

- (void)showNotSafeResult {
    self.ScanResultImage.hidden = NO;
    UIImage *buttonImage = [UIImage imageNamed: @"new-scan-red.png"];
    [self.NewScanButtonProperty setImage:buttonImage forState: UIControlStateNormal];
    UIImage *image = [UIImage imageNamed: @"x.png"];
    self.ScanResultImage.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        self.ScanResultImage.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    self.ScanResultImage.image = image;
    self.ScanResultText.text = @"This product is";
    self.ScanResultText.hidden = NO;
    self.ResultsLabel.text = @"not gluten free!";
    self.ResultsLabel.hidden = NO;
    self.NewScanButtonProperty.hidden = NO;
}

- (void)showNoResult {
    self.ScanResultImage.hidden = NO;
    UIImage *buttonImage = [UIImage imageNamed: @"new-scan-red.png"];
    [self.NewScanButtonProperty setImage:buttonImage forState: UIControlStateNormal];
    UIImage *image = [UIImage imageNamed: @"Question-Mark.jpg"];
    self.ScanResultImage.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        self.ScanResultImage.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    self.ScanResultImage.image = image;
    self.ScanResultText.text = @"Oops!";
    self.ScanResultText.hidden = NO;
    self.ResultsLabel.text = @"No results";
    self.ResultsLabel.hidden = NO;
    self.NewScanButtonProperty.hidden = NO;
}

-(void) hideCurrentResult{
    self.ScanResultImage.hidden = YES;
    self.ScanResultText.hidden = YES;
    self.NewScanButtonProperty.hidden = YES;
}
-(void)getScanResult: (NSString *) barcode {
    if(self.connection){
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"http://hopper.wlu.ca/~bull6280/gfz/php/gfz_get_scan_result.php"]];
        [request setHTTPMethod: @"POST"];
        NSUserDefaults *ns = [NSUserDefaults standardUserDefaults];
        NSString *email = [ns valueForKey:@"user_email"];
        NSString *post = [NSString stringWithFormat:@"email=%@&upc=%@", email, barcode];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        NSString *postLength = [NSString stringWithFormat:@"%d", [post length]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Add code here to do background processing
            [connection start];
        });
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection!"
                                                        message:@"Please ensure you have a valid data connection and try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    
    [self.data appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Failed with errors");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSString *response = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", response);
    // Do anything you want with it
    if([response isEqualToString:@"0"]){
        [self showSafeResult];
    }else if([response isEqualToString:@"1"]){
        [self showNotSafeResult];
    }else{
        [self showNoResult];
    }
}

// Handle basic authentication challenge if needed
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"challeneged");
}


- (IBAction)SignOutButton:(id)sender {
    NSLog(@"sign out");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// Checks if we have an internet connection or not
- (void)testInternetConnection
{
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.ca"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        self.connection = YES;
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        self.connection = NO;
    };
    
    [internetReachableFoo startNotifier];
}
@end

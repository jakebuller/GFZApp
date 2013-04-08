//
//  GFZViewController.m
//  Gluten Free Zone
//
//  Created by P & C on 3/20/13.
//  Copyright (c) 2013 P & C. All rights reserved.
//

#import "GFZLoginViewController.h"
#import "GFZCreateAccountViewController.h"
#import "GFZScanViewController.h"
#import "GFZMainViewController.h"
#import "GFZVerifyAccountViewController.h"
#import "GFZHistoryViewController.h"
#import "Reachability.h"

@interface GFZLoginViewController (){
    Reachability *internetReachableFoo;
}
@end

@implementation GFZLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self testInternetConnection];
	// Do any additional setup after loading the view, typically from a nib.
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
    self.EmailInputField.delegate = self;
    self.EmailInputField.text = @"";
    self.PasswordInputField.delegate = self;
    self.PasswordInputField.text = @"";
    self.data = [[NSMutableData alloc] initWithCapacity: 1024];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *ns = [NSUserDefaults standardUserDefaults];
    [ns removeObjectForKey:@"user_email"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SignInButton:(id)sender {
    [self testInternetConnection];
    NSLog(@"Sign In");
    if([self.EmailInputField.text isEqualToString: @""] || [self.PasswordInputField.text isEqualToString: @""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Login!"
                                                        message:@"Please enter your email address and password to login!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        if(self.connection){
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"http://hopper.wlu.ca/~bull6280/gfz/php/gfz_login.php"]];
        [request setHTTPMethod: @"POST"];
        NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", self.EmailInputField.text, self.PasswordInputField.text];
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
}

- (IBAction)CreateAccountButton:(id)sender {
    NSLog(@"Create Account");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    GFZCreateAccountViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"CreateAccountView"];
    viewController.delegate = self;
    [self.navigationController presentModalViewController:viewController animated:YES];
}

- (void)viewDidUnload {
    [self setEmailInputField:nil];
    [self setPasswordInputField:nil];
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"view dissapearing");
    self.EmailInputField.text = @"";
    self.PasswordInputField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int movementDistance = 100; // tweak as needed
        
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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
    // Do anything you want with it
    if([response isEqualToString:@"0"]){
        NSUserDefaults *ns = [NSUserDefaults standardUserDefaults];
        [ns setValue: self.EmailInputField.text forKey:@"user_email"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        UITabBarController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }else if([response isEqualToString:@"1"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Login!"
                                                        message:@"Please enter your email address and password to login!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else if([response isEqualToString:@"2"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        GFZVerifyAccountViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"VerifyAccountView"];
        viewController.email = self.EmailInputField.text;
        viewController.delegate = self;
        [self.navigationController presentModalViewController:viewController animated:YES];
    }
}

// Handle basic authentication challenge if needed
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"challeneged");
}

- (void) showVerified{
    NSLog(@"here");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome!"
                                                    message:@"Your account has been verified, welcome to Gluten Free Zone!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UITabBarController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
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

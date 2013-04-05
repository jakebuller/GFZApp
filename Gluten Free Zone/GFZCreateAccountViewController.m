//
//  GFZCreateAccountViewController.m
//  Gluten Free Zone
//
//  Created by P & C on 3/20/13.
//  Copyright (c) 2013 P & C. All rights reserved.
//

#import "GFZCreateAccountViewController.h"
#import "GFZLoginViewController.h"
#import "Reachability.h"

@interface GFZCreateAccountViewController (){
    Reachability *internetReachableFoo;
}

@end

@implementation GFZCreateAccountViewController
@synthesize delegate;
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
    [self.NavBar setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
    self.FirstNameField.delegate = self;
    self.LastNameField.delegate = self;
    self.EmailField.delegate = self;
    self.PasswordField.delegate = self;
    self.RetypePasswordField.delegate = self;
    self.data = [[NSMutableData alloc] initWithCapacity: 1024];
    self.created = NO;
    [self testInternetConnection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)CancelButton:(id)sender {
    [self dismissModalViewControllerAnimated: YES];
}
- (void)viewDidUnload {
    [self setFirstNameField:nil];
    [self setLastNameField:nil];
    [self setEmailField:nil];
    [self setPasswordField:nil];
    [self setRetypePasswordField:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
}
- (IBAction)CreateButton:(id)sender {
    if([self.EmailField.text isEqualToString:@""] || [self.PasswordField.text isEqualToString:@""] || [self.RetypePasswordField.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Create Account"
                                                        message:@"Please ensure you have filled in all field with an asterisk (*) and try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        if([self.PasswordField.text isEqualToString:self.RetypePasswordField.text]){
            if(self.connection){
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"http://hopper.wlu.ca/~bull6280/gfz/php/gfz_create_account.php"]];
                [request setHTTPMethod: @"POST"];
                NSString *post = [NSString stringWithFormat:@"first_name=%@&last_name=%@&email=%@&password=%@",self.FirstNameField.text, self.LastNameField.text, self.EmailField.text, self.PasswordField.text];
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
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passwords do not match"
                                                            message:@"Please make sure your passwords match and try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    
    }
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
    int movementDistance = 0; // tweak as needed
    if(textField == self.LastNameField){
        movementDistance = 40;
    }
    if(textField == self.EmailField){
        movementDistance = 100;
    }
    if(textField == self.PasswordField){
        movementDistance = 160;
    }
    if(textField == self.RetypePasswordField){
        movementDistance = 220;
    }
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
    NSLog(@"got some data");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Failed with errors");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"finished loading");
    NSString *data = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", data);
    if([data isEqualToString:@"0"]){
        self.created = YES;
        [self dismissModalViewControllerAnimated:YES];
    }else if([data isEqualToString: @"1"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Address Unavailable!"
                                                        message:@"Something went wrong trying to create your account, please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }else if([data isEqualToString: @"2"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Address Unavailable!"
                                                        message:@"This email address is already in use, please try again with a different email address."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection!"
                                                        message:@"Please ensure you have a valid data connection and try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

// Handle basic authentication challenge if needed
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"challeneged");
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(self.created){
        NSLog(@"hi");
        [self.delegate showVerified];
    }
}
@end

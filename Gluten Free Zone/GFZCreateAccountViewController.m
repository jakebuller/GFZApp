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
    [self.NavBar setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
    self.FirstNameField.delegate = self;
    self.LastNameField.delegate = self;
    self.EmailField.delegate = self;
    self.PasswordField.delegate = self;
    self.RetypePasswordField.delegate = self;
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"success!"
                                                            message:@"good to go."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
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

@end

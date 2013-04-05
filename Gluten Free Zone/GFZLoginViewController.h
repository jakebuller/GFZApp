//
//  GFZViewController.h
//  Gluten Free Zone
//
//  Created by P & C on 3/20/13.
//  Copyright (c) 2013 P & C. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GFZLoginViewController : UIViewController <UITextFieldDelegate, NSURLConnectionDelegate>
- (IBAction)SignInButton:(id)sender;
- (IBAction)CreateAccountButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *EmailInputField;		
@property (weak, nonatomic) IBOutlet UITextField *PasswordInputField;
@property (strong, nonatomic) NSMutableData *data;
@property BOOL connection;
- (void) showVerified;
@end

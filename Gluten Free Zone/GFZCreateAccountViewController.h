//
//  GFZCreateAccountViewController.h
//  Gluten Free Zone
//
//  Created by P & C on 3/20/13.
//  Copyright (c) 2013 P & C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFZCreateAccountViewController : UIViewController <UITextFieldDelegate>
- (IBAction)CancelButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *FirstNameField;
@property (weak, nonatomic) IBOutlet UITextField *LastNameField;
@property (weak, nonatomic) IBOutlet UITextField *EmailField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordField;
@property (weak, nonatomic) IBOutlet UITextField *RetypePasswordField;
- (IBAction)CreateButton:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *NavBar;

@end

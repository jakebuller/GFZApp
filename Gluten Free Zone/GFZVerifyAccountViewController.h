//
//  GFZVerifyAccountViewController.h
//  Gluten Free Zone
//
//  Created by P & C on 3/27/13.
//  Copyright (c) 2013 P & C. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GFZVerifyAccountViewController : UIViewController <UITextFieldDelegate, NSURLConnectionDelegate>
- (IBAction)CancelButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *CodeInputField;
- (IBAction)SubmitButton:(id)sender;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSString *email;
@property BOOL verified;
@property (nonatomic, assign) id delegate;
@end

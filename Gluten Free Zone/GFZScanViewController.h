//
//  GFZScanViewController.h
//  Gluten Free Zone
//
//  Created by P & C on 3/20/13.
//  Copyright (c) 2013 P & C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanditSDKOverlayController.h"

@interface GFZScanViewController : UIViewController <ScanditSDKOverlayControllerDelegate>
- (IBAction)NewScanButton:(id)sender;
- (IBAction)SignOutButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *ScanResultImage;
@property (strong, nonatomic) ScanditSDKBarcodePicker *picker;
@property (weak, nonatomic) IBOutlet UILabel *ScanResultText;
@property (weak, nonatomic) IBOutlet UILabel *ResultsLabel;
@property (strong, nonatomic) UINavigationController *navController;
@property (weak, nonatomic) IBOutlet UIButton *NewScanButtonProperty;
@end

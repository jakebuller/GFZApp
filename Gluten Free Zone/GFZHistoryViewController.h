//
//  GFZHistoryViewController.h
//  Gluten Free Zone
//
//  Created by P & C on 3/22/13.
//  Copyright (c) 2013 P & C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFZHistoryViewController : UITableViewController <NSURLConnectionDelegate, UITableViewDelegate>{
    NSMutableData *jsonData;
    NSMutableArray *tableData;
}
@property BOOL connection;
- (IBAction)SignOutButton:(id)sender;
- (IBAction)RefreshDataButton:(id)sender;
- (void)fetchEntries;
@end

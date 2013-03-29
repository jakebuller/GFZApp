//
//  GFZHistoryViewController.h
//  Gluten Free Zone
//
//  Created by P & C on 3/22/13.
//  Copyright (c) 2013 P & C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFZHistoryViewController : UITableViewController <NSURLConnectionDelegate>{
    NSMutableData *jsonData;
    NSMutableArray *tableData;
}
- (void)fetchEntries;
@end

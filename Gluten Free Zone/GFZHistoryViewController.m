//
//  GFZHistoryViewController.m
//  Gluten Free Zone
//
//  Created by P & C on 3/22/13.
//  Copyright (c) 2013 P & C. All rights reserved.
//

#import "GFZHistoryViewController.h"

@interface GFZHistoryViewController ()

@end

@implementation GFZHistoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tableData = [[NSMutableArray alloc] init];
    self.navigationItem.leftBarButtonItem = nil;
    NSUserDefaults *ns = [NSUserDefaults standardUserDefaults];
    NSLog(@"User email: %@", [ns valueForKey:@"user_email"]);
    [self fetchEntries];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Got a response");
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    NSLog(@"Got some data");
    // Add the incoming chunk of data to the container we are keeping
    // The data always comes in the correct order
    [jsonData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO
     ];	
    NSLog(@"Connection finished loading");
    // Create the parser object with the data received from the web service
   // NSXMLParser *parser = [[NSXMLParser alloc] initWithData:jsonData];
    
    // Give it a delegate
    //[parser setDelegate:self];
    
    // Tell it to start parsing - the document will be parsed and
    // the delegate of NSXMLParser will get all of its delegate messages
    // sent to it before this line finishes execution - it is blocking
    //[parser parse];
    
    NSString *response = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"Retrieved data: %@", response);
    NSError *error = [[NSError alloc] init];
    NSMutableDictionary *JSON = [NSJSONSerialization JSONObjectWithData: jsonData options: NSJSONReadingMutableContainers error: &error];
    NSLog(@"using dictionary: %@", [JSON valueForKey:@"history"]);
    NSMutableDictionary *items = [JSON valueForKey:@"history"];
    NSLog(@"using history: %@", [items valueForKey:@"1"]);
    int count = [[items valueForKey:@"count"] intValue];
    NSLog(@"number of items: %d", count);
    
    for (int i=0; i<count;i++) {
        NSLog(@"Theres an object here");
        NSString *key = [NSString stringWithFormat:@"%d",i];
        NSDictionary *item = [items valueForKey:key];
        NSLog(@"Item: %@", [item valueForKey:@"date"]);
        [tableData addObject:item];
    }
    // Reload the table.. for now, the table will be empty.
    [[self tableView] reloadData];
    
    //NSLog(@"%@\n %@\n %@\n", channel, [channel title], [channel infoString]);
}

- (void)connection:(NSURLConnection *)conn
  didFailWithError:(NSError *)error
{
        NSLog(@"Connection failed");
    // Release the jsonData object, we're done with it
    //jsonData = nil;
    
    // Grab the description of the error object passed to us
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@",
                             [error localizedDescription]];
    
    // Create and show an alert view with this error displayed
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:errorString
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"UITableViewCell"];
    }

    NSDictionary *item = [tableData objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[item valueForKey:@"product_title"]];
    cell.detailTextLabel.text = [item valueForKey:@"date"];
    bool result = [item valueForKey:@"result"];
    if(result){
        UIImage *image = [UIImage imageNamed:@"check.png"];
        [[cell imageView] setImage:image];
    }else{
        UIImage *image = [UIImage imageNamed:@"x.png"];
        [[cell imageView] setImage:image];
    }

    
    //RSSItem *item = [[channel items] objectAtIndex:[indexPath row]];
    //[[cell textLabel] setText:[item title]];
    
    return cell;
}

- (void)fetchEntries
{
    // Create a new data container for the stuff that comes back from the service
    jsonData = [[NSMutableData alloc] init];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"http://hopper.wlu.ca/~bull6280/gfz/php/gfz_get_history.php"]];
    [request setHTTPMethod: @"POST"];
    NSUserDefaults *ns = [NSUserDefaults standardUserDefaults];
    NSString *email = [ns valueForKey:@"user_email"];
    NSString *post = [NSString stringWithFormat:@"email=%@&count=%d", email, 10];
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
    

}

@end

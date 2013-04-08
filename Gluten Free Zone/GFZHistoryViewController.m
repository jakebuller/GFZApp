//
//  GFZHistoryViewController.m
//  Gluten Free Zone
//
//  Created by P & C on 3/22/13.
//  Copyright (c) 2013 P & C. All rights reserved.
//

#import "GFZHistoryViewController.h"
#import "Reachability.h"

@interface GFZHistoryViewController (){
    Reachability *internetReachableFoo;
}
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
    self.connection = YES;
    tableData = [[NSMutableArray alloc] init];
    self.navigationItem.leftBarButtonItem = nil;
    self.tableView.delegate = self;
    //NSUserDefaults *ns = [NSUserDefaults standardUserDefaults];
    //NSLog(@"User email: %@", [ns valueForKey:@"user_email"])
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [tableData removeAllObjects];
    [self fetchEntries];
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle {
    NSLog(@"delete this entry");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Got a response");
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    // Add the incoming chunk of data to the container we are keeping
    // The data always comes in the correct order
    [jsonData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO
     ];	
    NSError *error = [[NSError alloc] init];
    NSMutableDictionary *JSON = [NSJSONSerialization JSONObjectWithData: jsonData options: NSJSONReadingMutableContainers error: &error];
    NSMutableDictionary *items = [JSON valueForKey:@"history"];
    int count = [[items valueForKey:@"count"] intValue];
    
    for (int i=0; i<count;i++) {

        NSString *key = [NSString stringWithFormat:@"%d",i];
        NSDictionary *item = [items valueForKey:key];
        [tableData addObject:item];
    }
    // Reload the table.. for now, the table will be empty.
    [[self tableView] reloadData];
}

- (void)connection:(NSURLConnection *)conn
  didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed");    
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
    NSString *result = [item valueForKey:@"result"];
    if([result isEqualToString:@"1"]){
        UIImage *image = [UIImage imageNamed:@"check.png"];
        [[cell imageView] setImage:image];
    }else if([result isEqualToString:@"2"]){
        UIImage *image = [UIImage imageNamed:@"q.png"];
        [[cell imageView] setImage:image];
    }else{
        UIImage *image = [UIImage imageNamed:@"x.png"];
        [[cell imageView] setImage:image];
    }

    
    //RSSItem *item = [[channel items] objectAtIndex:[indexPath row]];
    //[[cell textLabel] setText:[item title]];
    
    return cell;
}

- (IBAction)SignOutButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)RefreshDataButton:(id)sender {
    [self testInternetConnection];
    if(self.connection){
        [tableData removeAllObjects];
        [[self tableView] reloadData];
        [self fetchEntries];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection!"
                                                        message:@"Please ensure you have a valid data connection and try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)fetchEntries
{
    [self testInternetConnection];
    if(self.connection){
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
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection!"
                                                        message:@"Please ensure you have a valid data connection and try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

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

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end

//
//  RecipeBookViewController.m
//  RecipeBook
//
//  Created by Simon Ng on 14/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import "GymPoolViewController.h"
#import "GymPoolDetailViewController.h"
#import "GymPool.h"

@interface GymPoolViewController ()

@end

@implementation GymPoolViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Initialize table data
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Gym";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        self.objectsPerPage = 10;
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"GymPoolCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell
    PFFile *thumbnail = [object objectForKey:@"imageFile"];
    PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:100];
    thumbnailImageView.image = [UIImage imageNamed:@"white.jpg"];
    thumbnailImageView.file = thumbnail;
    [thumbnailImageView loadInBackground];
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = [object objectForKey:@"name"];
    
    UILabel *prepTimeLabel = (UILabel*) [cell viewWithTag:102];
    NSDateFormatter* day = [[NSDateFormatter alloc] init];
    [day setDateFormat: @"EEEE"];
    NSString *dayOfTheWeek = [day stringFromDate:[NSDate date]];
    NSLog(@"%@", dayOfTheWeek);
    
    NSArray *hours = [object objectForKey: dayOfTheWeek];
    NSMutableString *currentHours = [[NSMutableString alloc] init];
    
    if ([[hours objectAtIndex: 0] isEqualToString: @"Closed"])  {
        [currentHours appendFormat:@"%@", [hours objectAtIndex: 0]];
    }
    
    else {
        [currentHours appendFormat:@"%@ to %@", [hours objectAtIndex: 0], [hours objectAtIndex: 1]];
    }
    
    prepTimeLabel.text = currentHours;
    
    return cell;
}

- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSLog(@"error: %@", [error localizedDescription]);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showGymPoolDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GymPoolDetailViewController *destViewController = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        GymPool *gympool = [[GymPool alloc] init];
        gympool.name = [object objectForKey:@"name"];
        gympool.imageFile = [object objectForKey:@"imageFile"];
        gympool.prepTime = [object objectForKey:@"name"];
        gympool.hours = [NSArray arrayWithObjects: [object objectForKey:@"Monday"], [object objectForKey:@"Tuesday"], [object objectForKey:@"Wednesday"], [object objectForKey:@"Thursday"], [object objectForKey:@"Friday"], [object objectForKey:@"Saturday"], [object objectForKey:@"Sunday"], nil];
        destViewController.gympool = gympool;
}
}


@end

//
//  RecipeBookViewController.m
//  RecipeBook
//
//  Created by Simon Ng on 14/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import "FoodViewController.h"
#import "FoodDetailViewController.h"
#import "Food.h"

@interface FoodViewController ()

@end

@implementation FoodViewController

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
        self.parseClassName = @"Eateries";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        self.objectsPerPage = 20;
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    return query;
}

// Checks if the time is before 3:00 AM

- (BOOL)before3am
{
    NSCalendar *gregorianCalender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalender components:NSHourCalendarUnit fromDate:[NSDate date]];
    if([components hour] <= 3)
        return YES;
    return NO;
    
}

// convert to a NSDate from the current day
- (NSDate *)todaysDateFromAMPMString:(NSString *)time
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    
    // Get year-month-day for today:
    [fmt setDateFormat:@"yyyy-MM-dd "];
    NSString *todayString = [fmt stringFromDate:[NSDate date]];
    
    // Append the given time:
    NSString *todaysTime = [todayString stringByAppendingString:time];
    
    // Convert date+time string back to NSDate:
    [fmt setDateFormat:@"yyyy-MM-dd h:mma"];
    NSDate *date = [fmt dateFromString:todaysTime];
    return date;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"FoodCell";
    
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
    
    // Gets current day
    
    UILabel *prepTimeLabel = (UILabel*) [cell viewWithTag:102];
    NSDate* day = [[NSDate alloc] init];
    // Some places open past 12:00 am. For example, Jay's Place opens until 2 AM on Saturdays, and don't
    // want the app to show Jay's Sunday hours when it is between 12 and 2 AM on Sunday.
    
    if ([self before3am]) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *today = [NSDate date];
        
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = -1;
        
        NSDate *yesterday = [gregorian dateByAddingComponents:dayComponent toDate:today options:0];
        day = yesterday;
    }
    NSDateFormatter *currentDay = [[NSDateFormatter alloc] init];
    [currentDay setDateFormat: @"EEEE"];
    NSString *dayOfTheWeek = [currentDay stringFromDate:day];
    NSLog(@"%@", dayOfTheWeek);
    
    NSArray *hours = [object objectForKey: dayOfTheWeek];
    NSMutableString *currentHours = [[NSMutableString alloc] init];
    
    if ([[hours objectAtIndex: 0] isEqualToString: @"Closed"])  {
        [currentHours appendFormat:@"%@", [hours objectAtIndex: 0]];
        prepTimeLabel.backgroundColor = [UIColor redColor];
    }
    else {
        [currentHours appendFormat:@"%@ to %@", [hours objectAtIndex: 0], [hours objectAtIndex: 1]];
    }
    
    prepTimeLabel.text = currentHours;
    
    if (![[hours objectAtIndex: 0] isEqualToString: @"Closed"]) {
        NSString *strOpenTime = [hours objectAtIndex: 0];
        NSString *strCloseTime = [hours objectAtIndex: 1];
        
        NSDate *openTime = [self todaysDateFromAMPMString:strOpenTime];
        NSDate *closeTime = [self todaysDateFromAMPMString:strCloseTime];
        
        if ([closeTime compare:openTime] != NSOrderedDescending) {
            // closeTime is less than or equal to openTime, so add one day:
            if([self before3am]) {
                NSCalendar *cal = [NSCalendar currentCalendar];
                NSDateComponents *comp = [[NSDateComponents alloc] init];
                [comp setDay:-1];
                openTime = [cal dateByAddingComponents:comp toDate:openTime options:0];
            }
            else {
                NSCalendar *cal = [NSCalendar currentCalendar];
                NSDateComponents *comp = [[NSDateComponents alloc] init];
                [comp setDay:1];
                closeTime = [cal dateByAddingComponents:comp toDate:closeTime options:0];
            }
        }
        
        NSDate *now = [NSDate date];
        
        if ([now compare:openTime] != NSOrderedAscending &&
            [now compare:closeTime] != NSOrderedDescending) {
            prepTimeLabel.backgroundColor = [UIColor greenColor];
            prepTimeLabel.textColor = [UIColor blackColor];
        } else {
            prepTimeLabel.backgroundColor = [UIColor redColor];
        }
    }
    
    return cell;
}
- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSLog(@"error: %@", [error localizedDescription]);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFoodDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        FoodDetailViewController *destViewController = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        Food *food = [[Food alloc] init];
        food.name = [object objectForKey:@"name"];
        food.imageFile = [object objectForKey:@"imageFile"];
        food.prepTime = [object objectForKey:@"name"];
        food.hours = [NSArray arrayWithObjects: [object objectForKey:@"Monday"], [object objectForKey:@"Tuesday"], [object objectForKey:@"Wednesday"], [object objectForKey:@"Thursday"], [object objectForKey:@"Friday"], [object objectForKey:@"Saturday"], [object objectForKey:@"Sunday"], nil];
        destViewController.food = food;
    }
}


@end

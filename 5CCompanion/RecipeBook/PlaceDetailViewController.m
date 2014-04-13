//
//  RecipeDetailViewController.m
//  RecipeBook
//
//  Created by Simon Ng on 17/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import "PlaceDetailViewController.h"

@interface PlaceDetailViewController () {
    NSArray *dayOfWeek;
    NSUInteger tab;
}
@end

@implementation PlaceDetailViewController

@synthesize placePhoto;
@synthesize place;
@synthesize favButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([place.tab isEqualToString:@"Dining"]) {
        dayOfWeek = [[NSArray alloc] initWithObjects:
                     @"Breakfast",
                     @"Lunch",
                     @"Dinner",
                     @"Weekend Brunch",
                     @"Weekend Dinner",
                     nil];
    }
    else {
        dayOfWeek = [[NSArray alloc] initWithObjects:
                     @"Monday",
                     @"Tuesday",
                     @"Wednesday",
                     @"Thursday",
                     @"Friday",
                     @"Saturday",
                     @"Sunday",
                     nil];
    }
    
    self.title = place.name;
    self.placePhoto.image = place.imageFile;
    self.phoneLabel.text = place.phone;
    tab = self.tabBarController.selectedIndex;
    if(tab == 4) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"] containsObject:[NSString stringWithString:place.name]]) {
            self.favButton.selected = YES;
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"] containsObject:[NSString stringWithString:place.name]]) {
		self.favButton.selected = YES;
	}
    else {
        self.favButton.selected = NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dayOfWeek count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"hoursCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell
    UITextView *dayText = (UITextView*) [cell viewWithTag:200];
    dayText.text = [dayOfWeek objectAtIndex:indexPath.row];
    
    // Gets current day
    
    UITextView *hoursText = (UITextView*) [cell viewWithTag:201];
    NSMutableString *hourText = [NSMutableString string];
    NSArray* hours = [place.hours objectAtIndex:indexPath.row];
    if ([[hours objectAtIndex: 0] isEqualToString: @"Closed"])  {
        [hourText appendFormat:@"%@", [hours objectAtIndex: 0]];
    }
    else {
        [hourText appendFormat:@"%@ - %@", [hours objectAtIndex: 0], [hours objectAtIndex: 1]];
        if ([place.tab isEqualToString:@"Dining"]) {
            if (hours.count == 4) {
                [hourText appendFormat:@"\n%@ - %@", [hours objectAtIndex: 2], [hours objectAtIndex: 3]];
            }
            if (hours.count == 6) {
                [hourText appendFormat:@"\n%@ - %@", [hours objectAtIndex: 4], [hours objectAtIndex: 5]];
            }
        }
        else {
            
            if (hours.count == 4) {
                [hourText appendFormat:@"\n%@ - %@", [hours objectAtIndex: 2], [hours objectAtIndex: 3]];
            }
        }
    }
    hoursText.text = hourText;
    dayText.font = [UIFont fontWithName:@"AvenirNext-Medium" size:12.0f];
    hoursText.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12.0f];
    
    return cell;
}

-(IBAction)toggleFav:(UIButton *)sender {
    if([sender isSelected]){
        //...
        [sender setSelected:NO];
		NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"] mutableCopy];
		[array removeObject:[NSString stringWithString:place.name]];
		[[NSUserDefaults standardUserDefaults] setObject:array forKey:@"favorites"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (tab == 4) {
        [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        //...
        [sender setSelected:YES];
		NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"] mutableCopy];
		[array addObject:[NSString stringWithString:place.name]];
		[[NSUserDefaults standardUserDefaults] setObject:array forKey:@"favorites"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* hours = [place.hours objectAtIndex:indexPath.row];
    CGFloat height;
    
    static NSString *simpleTableIdentifier = @"hoursCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UITextView *dayText = (UITextView*) [cell viewWithTag:200];
    dayText.text = [dayOfWeek objectAtIndex:indexPath.row];
    if ([dayText.text isEqualToString:@"Weekend Brunch"] || [dayText.text isEqualToString:@"Weekend Dinner"] || hours.count > 3) {
        height = 60;
    }
    else {
        height = 40;
    }
    
    
    UITextView *hoursText = (UITextView*) [cell viewWithTag:201];
    CGRect frame = hoursText.frame;
    frame.size.height = height - 10;
    hoursText.frame = frame;
    dayText.frame = frame;
    return height;
}

- (void)viewDidUnload
{
    [self setPlacePhoto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
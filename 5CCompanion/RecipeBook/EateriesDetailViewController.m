//
//  RecipeDetailViewController.m
//  RecipeBook
//
//  Created by Simon Ng on 17/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import "EateriesDetailViewController.h"

@interface EateriesDetailViewController () {
    NSArray *dayOfWeek;
}
@end

@implementation EateriesDetailViewController

@synthesize eateryPhoto;
@synthesize eatery;


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
    dayOfWeek = [[NSArray alloc] initWithObjects:
                 @"Monday",
                 @"Tuesday",
                 @"Wednesday",
                 @"Thursday",
                 @"Friday",
                 @"Saturday",
                 @"Sunday",
                 nil];
    
    self.title = eatery.name;
    self.eateryPhoto.file = eatery.imageFile;
    
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
    NSArray* hours = [eatery.hours objectAtIndex:indexPath.row];
    if ([[hours objectAtIndex: 0] isEqualToString: @"Closed"])  {
        [hourText appendFormat:@"%@", [hours objectAtIndex: 0]];
    }
    else {
        [hourText appendFormat:@"%@ - %@", [hours objectAtIndex: 0], [hours objectAtIndex: 1]];
        if (hours.count == 4) {
            [hourText appendFormat:@"\n%@ - %@", [hours objectAtIndex: 2], [hours objectAtIndex: 3]];
        }
    }
    hoursText.text = hourText;
    
    return cell;
}


- (void)viewDidUnload
{
    [self setEateryPhoto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
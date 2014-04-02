//
//  RecipeDetailViewController.h
//  RecipeBook
//
//  Created by Simon Ng on 17/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface FavoritesDetailViewController : UIViewController {
	UIButton *favButton;
}

@property(retain) IBOutlet UIButton *favButton;
@property (weak, nonatomic) IBOutlet PFImageView *placePhoto;
@property (nonatomic, strong) Place *place;
-(IBAction)toggleFav:(UIButton *)sender;

@end


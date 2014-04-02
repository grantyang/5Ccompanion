//
//  RecipeDetailViewController.h
//  RecipeBook
//
//  Created by Simon Ng on 17/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GymPool.h"

@interface GymPoolDetailViewController : UIViewController {
	UIButton *favButton;
}

@property(retain) IBOutlet UIButton *favButton;
@property (weak, nonatomic) IBOutlet PFImageView *gymPoolPhoto;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic, strong) GymPool *gympool;
-(IBAction)toggleFav:(UIButton *)sender;

@end

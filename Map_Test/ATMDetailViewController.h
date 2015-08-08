//
//  ATMDetailViewController.h
//  Map_Test
//
//  Created by optimusmac-12 on 06/08/15.
//  Copyright (c) 2015 mdtaha.optimus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ATMDetailViewController : UIViewController <CLLocationManagerDelegate>
@property (nonatomic,weak) NSArray *atmDetail;
@property (weak, nonatomic) IBOutlet UITextView *addText;

@property (nonatomic,weak) NSString *picUrl;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (nonatomic,weak) NSString *nameActual;
@property (weak, nonatomic) IBOutlet UITextView *nameTextField;

@property (nonatomic) NSString *vicinityActual;

@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

@end

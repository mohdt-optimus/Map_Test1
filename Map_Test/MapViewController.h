//
//  MapViewController.h
//  Map_Test
//
//  Created by optimusmac-12 on 06/08/15.
//  Copyright (c) 2015 mdtaha.optimus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <LocalAuthentication/LocalAuthentication.h>
//#define kGOOGLE_API_KEY @"AIzaSyBDRvDp6oMGJIRDuHLr2JiUclOuY-Kn0HY"
  #define kGOOGLE_API_KEY @"AIzaSyB2FW3RI3z8JGuH1xLnJDO07CVnXGpm1mg"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate,UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLLocation *location;
@property(nonatomic,strong) NSString *address;

@end

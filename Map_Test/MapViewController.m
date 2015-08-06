//
//  MapViewController.m
//  Map_Test
//
//  Created by optimusmac-12 on 06/08/15.
//  Copyright (c) 2015 mdtaha.optimus. All rights reserved.
//

#import "MapViewController.h"
#import "CustomAnnotation.h"
#import "Pins.h"
#import "ATMDetailViewController.h"

@interface MapViewController ()
{
    NSArray *places;
}
@end

@implementation MapViewController

CLLocationManager *manager;
CLGeocoder *geocoder;
CLPlacemark *placemark;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [_mapView setDelegate:self];
    [[self mapView] setShowsUserLocation:YES];
    manager = [[CLLocationManager alloc] init];
    
    geocoder = [[CLGeocoder alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    
    [[self locationManager] setDelegate:self];
    
    
    if ([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[self locationManager] requestWhenInUseAuthorization];
    }
    
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    [[self locationManager] startUpdatingLocation];
    MKCoordinateRegion loc = { {0.0, 0.0} , {0.0, 0.0} };
    loc.center.latitude = 26.4661371;
    loc.center.longitude = 80.3625024;
    loc.span.longitudeDelta = 0.02f;
    loc.span.latitudeDelta = 0.02f;
    [_mapView setRegion:loc animated:YES];
    [self queryGooglePlaces:@"atm"];
    CustomAnnotation *annot1 = [[CustomAnnotation alloc] init];
    annot1.title = @"Are you Here ?";
    
    CLLocation *ourcoordinate=[[CLLocation alloc] initWithLatitude:26.4661371 longitude:80.3625024];
    
    
    [geocoder reverseGeocodeLocation:ourcoordinate completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            
            placemark = [placemarks lastObject];
            
            _address = [NSString stringWithFormat:@"%@ %@ %@ %@",
                        
                        placemark.postalCode, placemark.locality,
                        placemark.administrativeArea,
                        placemark.country];
            annot1.subtitle = _address;
            
        }
    }];
    annot1.coordinate = loc.center;
   
    
    [_mapView addAnnotation: annot1];
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *MyPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    MyPin.pinColor = MKPinAnnotationColorPurple;
    
    UIButton *myDetailButton =
    [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    myDetailButton.frame = CGRectMake(0, 0, 23, 23);
    myDetailButton.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    myDetailButton.contentHorizontalAlignment =
    UIControlContentHorizontalAlignmentCenter;
    
    [myDetailButton addTarget:self
                       action:@selector (checkButtonTapped)
             forControlEvents:UIControlEventTouchUpInside];
    
    MyPin.rightCalloutAccessoryView = myDetailButton;
 
    MyPin.draggable = NO;
    MyPin.highlighted = YES;
    MyPin.animatesDrop=TRUE;
    MyPin.canShowCallout = YES;
    
    return MyPin;
}

-(void) checkButtonTapped{
    [self performSegueWithIdentifier:@"callView" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"callView"])
    {
        ATMDetailViewController *detail=segue.destinationViewController;
        detail.atmDetail=places;
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) queryGooglePlaces: (NSString *) googleType {
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&key=%@&sensor=true", 51.50063, -0.124629, [NSString stringWithFormat:@"%i", 500],googleType,kGOOGLE_API_KEY];
    
    //Creating url fro fetching the atm.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // fetching results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

-(void)fetchedData:(NSData *)responseData {
    //parseing json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                            JSONObjectWithData:responseData
                            
                            options:kNilOptions
                            error:&error];
    
    //data about atm is obtained in NSDictionary
    places = [json objectForKey:@"results"];
    [self plotPositions:places];
}

-(void)plotPositions:(NSArray *)data {
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        if ([annotation isKindOfClass:[Pins class]]) {
            [_mapView removeAnnotation:annotation];
        }
    }
    for (int i=0; i<[data count]; i++) {
        //fetching details of all atm one by one
        NSDictionary* place = [data objectAtIndex:i];
        NSDictionary *geo = [place objectForKey:@"geometry"];
        NSDictionary *loc = [geo objectForKey:@"location"];
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        CLLocationCoordinate2D placeCoord;
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        Pins *placeObject = [[Pins alloc] initWithName:name address:vicinity coordinate:placeCoord];
        [_mapView addAnnotation:placeObject];
    }
}
@end

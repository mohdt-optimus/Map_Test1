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
    UIView *calloutView;
    NSString *check;
}
@end

@implementation MapViewController

CLGeocoder *geocoder;
CLPlacemark *placemark;


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.mapView.delegate=self;
    // Do any additional setup after loading the view.
    [_mapView setDelegate:self];
    geocoder = [[CLGeocoder alloc] init];
    MKCoordinateRegion loc = { {0.0, 0.0} , {0.0, 0.0} };
    loc.center.latitude = 26.4661371;
    loc.center.longitude = 80.3625024;
    loc.span.longitudeDelta = 0.02f;
    loc.span.latitudeDelta = 0.02f;
    [_mapView setRegion:loc animated:YES];
    [self queryGooglePlaces:@"atm"];
    CustomAnnotation *annot1 = [[CustomAnnotation alloc] init];
    CLLocation *ourcoordinate=[[CLLocation alloc] initWithLatitude:26.4661371 longitude:80.3625024];

    [geocoder reverseGeocodeLocation:ourcoordinate completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            
            placemark = [placemarks lastObject];
            
            NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
            _address = [lines componentsJoinedByString:@", "];
            annot1.subtitle = _address;
            
        }
    }];
    annot1.coordinate = loc.center;
    [_mapView addAnnotation: annot1];
    
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    MKAnnotationView *myPin=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    myPin.image=[UIImage imageNamed:@"map_pin.png"];
    return myPin;
   
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    CGSize  calloutSize = CGSizeMake(200.0, 80.0);
    calloutView = [[UIView alloc] initWithFrame:CGRectMake((view.frame.origin.x)/2-10, view.frame.origin.y-calloutSize.height, calloutSize.width, calloutSize.height)];
    
    calloutView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    UITextField *title=[[UITextField alloc] initWithFrame:CGRectMake(50, 10, 300, 20)];
    
    [title setTextColor:[UIColor whiteColor]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    calloutView.layer.cornerRadius = 5;
    calloutView.clipsToBounds = YES;
    button.frame = CGRectMake(80,45,30,20);
    [button setTitle:@"OK" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [title setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16 ]];
    [button setBackgroundColor:[UIColor whiteColor]];
    
    if(![view.annotation isKindOfClass:[CustomAnnotation class]]) {
        title.text=@"ATM Near You";
        [button addTarget:self action:@selector(atmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [calloutView addSubview:title];
        [calloutView addSubview:button];
        [view.superview addSubview:calloutView];
    }
       
    else if(![view.annotation isKindOfClass:[MKUserLocation class]]) {
        title.text=@"Are You Here ?";
        [button addTarget:self action:@selector(locButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [calloutView addSubview:title];
        [calloutView addSubview:button];
        [view.superview addSubview:calloutView];
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    [calloutView removeFromSuperview];
}
-(void) atmButtonTapped{
    check=@"atm";
    [self performSegueWithIdentifier:@"callView" sender:self];
}
-(void) locButtonTapped{
    check=@"loc";
    [self performSegueWithIdentifier:@"callView" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    Pins *annot = [[_mapView selectedAnnotations] objectAtIndex:0];
    if([check isEqualToString:@"loc"]){

        ATMDetailViewController *detail=segue.destinationViewController;
        detail.nameActual=@"This is your Location";
        detail.vicinityActual=_address;
        detail.picUrl=nil;
        check=nil;
    }else if ([check isEqualToString:@"atm"]){
        ATMDetailViewController *detail=segue.destinationViewController;
        detail.nameActual=annot.name;
        detail.vicinityActual=annot.address;
        detail.picUrl=annot.picUrl;
        check=nil;
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
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&key=%@&sensor=true", 26.4661371, 80.3625024, [NSString stringWithFormat:@"%i", 500],googleType,kGOOGLE_API_KEY];
    
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
        NSString *icon=[place objectForKey:@"icon"];
        CLLocationCoordinate2D placeCoord;
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        Pins *placeObject = [[Pins alloc] initWithName:name address:vicinity picUrl:icon coordinate:placeCoord ];
        [_mapView addAnnotation:placeObject];
        
    }
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    [calloutView removeFromSuperview];
}
@end

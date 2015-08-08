//
//  Pins.h
//  Map_Test
//
//  Created by optimusmac-12 on 06/08/15.
//  Copyright (c) 2015 mdtaha.optimus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Pins : NSObject <MKAnnotation>

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (copy) NSString *picUrl;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

//@property (copy) NSString *url;


- (id)initWithName:(NSString*)name address:(NSString*)address picUrl:(NSString*)picUrl coordinate:(CLLocationCoordinate2D)coordinate;

@end


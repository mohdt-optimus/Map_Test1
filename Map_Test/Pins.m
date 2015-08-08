//
//  Pins.m
//  Map_Test
//
//  Created by optimusmac-12 on 06/08/15.
//  Copyright (c) 2015 mdtaha.optimus. All rights reserved.
//

#import "Pins.h"

@implementation Pins

-(id)initWithName:(NSString*)name address:(NSString*)address picUrl:(NSString*)picUrl coordinate:(CLLocationCoordinate2D)coordinate   {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
        _picUrl=[picUrl copy];
        
        //_url=[url copy];
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return @"ATM";
}

- (NSString *)subtitle {
    return @"Near to You";
}


@end

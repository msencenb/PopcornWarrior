//
//  Day.h
//  PopcornWarrior
//
//  Created by Matt Sencenbaugh on 7/21/13.
//  Copyright (c) 2013 Matt Sencenbaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Customer.h"

@class GarageSaleLayer, Weather;
@interface Day : NSObject<CustomerDelegate>

-(id)initWithLayer:(GarageSaleLayer *)layer withPopcornPrice:(NSDecimalNumber *)popcornPrice withSodaPrice:(NSDecimalNumber *)sodaPrice withWeather:(Weather *)weather;

@property(nonatomic,strong)NSDecimalNumber *popcornPrice;
@property(nonatomic,strong)NSDecimalNumber *sodaPrice;

@property(nonatomic,strong)NSDecimalNumber *popcornSold;
@property(nonatomic,strong)NSDecimalNumber *sodaSold;

@property(nonatomic,strong)Weather *weather;

-(NSDecimalNumber *)revenue;

@end

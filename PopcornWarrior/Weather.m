//
//  Weather.m
//  PopcornWarrior
//
//  Created by Matt Sencenbaugh on 8/4/13.
//  Copyright (c) 2013 Matt Sencenbaugh. All rights reserved.
//

#import "Weather.h"

@implementation Weather
@synthesize readableForecast = _readableForecast, backgroundImageName = _backgroundImageName, addCustomerRatio = _addCustomerRatio;

+(Weather *)getSunnyDay
{
    Weather *sunny = [[Weather alloc] init];
    sunny.readableForecast = @"Sunny";
    sunny.backgroundImageName = @"Rolling-Hills.png";
    sunny.addCustomerRatio = 3;
    return sunny;
}

+(Weather *)getSuperHotDay
{
    Weather *sunny = [[Weather alloc] init];
    sunny.readableForecast = @"SuperHot";
    sunny.backgroundImageName = @"superhot_background.png";
    sunny.addCustomerRatio = 2;
    return sunny;
}

+(Weather *)getRandomWeather
{
    if (arc4random_uniform(75) % 2 == 0) {
        return [self getSunnyDay];
    }
    return [self getSuperHotDay];
}

@end

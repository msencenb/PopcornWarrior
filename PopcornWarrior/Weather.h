//
//  Weather.h
//  PopcornWarrior
//
//  Created by Matt Sencenbaugh on 8/4/13.
//  Copyright (c) 2013 Matt Sencenbaugh. All rights reserved.
//

//Weather needs to be 

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface Weather : NSObject

@property(nonatomic,strong)NSString *readableForecast;
@property(nonatomic,strong)NSString *backgroundImageName;
@property(nonatomic,assign)int addCustomerRatio;
//Need ratios and what not

+(Weather *)getRandomWeather;

@end

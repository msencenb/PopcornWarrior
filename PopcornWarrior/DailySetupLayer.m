//
//  DailySetupLayer.m
//  PopcornWarrior
//
//  Created by Matt Sencenbaugh on 7/23/13.
//  Copyright 2013 Matt Sencenbaugh. All rights reserved.
//

#import "DailySetupLayer.h"
#import "GarageSaleLayer.h"
#import "Weather.h"

@interface DailySetupLayer ()
{
}
@property(nonatomic,strong)NSDecimalNumber *sodaPrice;
@property(nonatomic,strong)NSDecimalNumber *popcornPrice;
@property(nonatomic,strong)Weather *weather;
@end


@implementation DailySetupLayer
@synthesize sodaPrice = _sodaPrice, popcornPrice = _popcornPrice, weather = _weather;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	DailySetupLayer *layer = [DailySetupLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void)addStartMenu
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCMenuItem *start = [CCMenuItemFont itemWithString:@"Start" block:^(id sender){
        NSLog(@"Startgame pressed");
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GarageSaleLayer sceneWithPopcornPrice:self.popcornPrice withSodaPrice:self.sodaPrice withWeather:self.weather] ]];
    }];
    
    CCMenu *menu = [CCMenu menuWithItems:start, nil];
    [menu setPosition:ccp( size.width - 50, size.height - 20 )];
    [self addChild:menu];
}

-(NSString *)stringForDecimalNumber:(NSDecimalNumber *)number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    return [formatter stringFromNumber:number];
}


-(void)addPricingMenus
{
    NSDecimalNumber *fiveCents = [[NSDecimalNumber alloc] initWithDouble:0.05];
    
    CCMenuItemFont *popcornPrice = [CCMenuItemFont itemWithString:@".25"];
    CCMenuItemFont *plusPopcorn = [CCMenuItemFont itemWithString:@"+" block:^(id sender){
        NSLog(@"Add money to popcorn");
        NSDecimalNumber *newPrice = [self.popcornPrice decimalNumberByAdding:fiveCents];
        self.popcornPrice = newPrice;
        [popcornPrice setString:[self stringForDecimalNumber:self.popcornPrice]];
    }];
    CCMenuItemFont *minusPopcorn = [CCMenuItemFont itemWithString:@"-" block:^(id sender){
        NSLog(@"subtract money to popcorn");
        NSDecimalNumber *newPrice = [self.popcornPrice decimalNumberBySubtracting:fiveCents];
        self.popcornPrice = newPrice;
        [popcornPrice setString:[self stringForDecimalNumber:self.popcornPrice]];
    }];
    CCMenu *popcornMenu = [CCMenu menuWithItems:minusPopcorn,popcornPrice, plusPopcorn, nil];
    [popcornMenu alignItemsHorizontallyWithPadding:10.0f];
    [popcornMenu setPosition:ccp(150,35)];
    [self addChild:popcornMenu];
    CCSprite *popcornSprite = [CCSprite spriteWithFile:@"popcorn_bubble.png"];
    popcornSprite.position = ccp(50,50);
    [self addChild:popcornSprite];
    CCMenuItemFont *sodaPrice = [CCMenuItemFont itemWithString:@".75"];
    
    CCMenuItemFont *plusSoda = [CCMenuItemFont itemWithString:@"+" block:^(id sender){
        NSLog(@"Add money to soda");
        NSDecimalNumber *newPrice = [self.sodaPrice decimalNumberByAdding:fiveCents];
        self.sodaPrice = newPrice;
        [sodaPrice setString:[self stringForDecimalNumber:self.sodaPrice]];
    }];
    CCMenuItemFont *minusSoda = [CCMenuItemFont itemWithString:@"-" block:^(id sender){
        NSLog(@"subtract money to soda");
        NSDecimalNumber *newPrice = [self.sodaPrice decimalNumberBySubtracting:fiveCents];
        self.sodaPrice = newPrice;
        [sodaPrice setString:[self stringForDecimalNumber:self.sodaPrice]];
    }];
    CCMenu *sodaMenu = [CCMenu menuWithItems:minusSoda,sodaPrice, plusSoda, nil];
    [sodaMenu alignItemsHorizontallyWithPadding:10.0f];
    [sodaMenu setPosition:ccp(150,100)];
    [self addChild:sodaMenu];
    CCSprite *sodaSprite = [CCSprite spriteWithFile:@"soda_bubble.png"];
    sodaSprite.position = ccp(50,115);
    [self addChild:sodaSprite]; 
}

-(void)addWeatherForecast
{
    self.weather = [Weather getRandomWeather];
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSprite *weather = [CCSprite spriteWithFile:self.weather.backgroundImageName];
    weather.position = ccp(size.width/2, size.height-75);
    [self addChild:weather];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        [self addWeatherForecast];
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Weekend 1 - Day 1" fontName:@"Helvetica-Bold" fontSize:32];
		label.position =  ccp( 150 , size.height - 20 );
        [self addChild: label];
        
        [self addStartMenu];
        
        self.popcornPrice = [[[NSDecimalNumber alloc] initWithDouble:0.25] autorelease];
        self.sodaPrice = [[[NSDecimalNumber alloc] initWithDouble:0.75] autorelease];
		
        [self addPricingMenus];
        
	}
	return self;
}

@end

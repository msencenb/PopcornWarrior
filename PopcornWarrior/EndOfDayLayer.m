//
//  EndOfDayLayer.m
//  PopcornWarrior
//
//  Created by Matt Sencenbaugh on 7/27/13.
//  Copyright 2013 Matt Sencenbaugh. All rights reserved.
//

#import "EndOfDayLayer.h"
@interface EndOfDayLayer ()
{
    
}
@property(nonatomic,strong)Day *completedDay;
@end

@class Day;
@implementation EndOfDayLayer
@synthesize completedDay = _completedDay;
+(CCScene *)sceneWithCompletedDay:(Day *)day
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
    EndOfDayLayer *layer = [EndOfDayLayer nodeWithCompletedDay:day];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+(id)nodeWithCompletedDay:(Day *)day
{
    return [[EndOfDayLayer alloc] initWithCompletedDay:day];
}

-(id)initWithCompletedDay:(Day *)day
{
    if( (self=[super init]) ) {
        self.completedDay = day;
    }
    return self;
}

@end

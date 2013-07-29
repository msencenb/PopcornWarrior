//
//  EndOfDayLayer.h
//  PopcornWarrior
//
//  Created by Matt Sencenbaugh on 7/27/13.
//  Copyright 2013 Matt Sencenbaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class Day;
@interface EndOfDayLayer : CCLayer {
    
}
+(CCScene *)sceneWithCompletedDay:(Day *)day;
+(id)nodeWithCompletedDay:(Day *)day;
@end

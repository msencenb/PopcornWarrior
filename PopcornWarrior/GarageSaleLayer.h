//
//  GarageSaleLayer.h
//  PopcornWarrior
//
//  Created by Matt Sencenbaugh on 7/16/13.
//  Copyright 2013 Matt Sencenbaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GarageSaleLayer : CCLayer {
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *)sceneWithPopcornPrice:(NSDecimalNumber *)popcornPrice withSodaPrice:(NSDecimalNumber *)sodaPrice;
+(id)nodeWithPopcornPrice:(NSDecimalNumber *)popcornPrice withSodaPrice:(NSDecimalNumber *)sodaPrice;

@property(nonatomic,strong)CCLabelAtlas *popcornLabel;
@property(nonatomic,strong)CCLabelAtlas *sodaLabel;
@property(nonatomic,strong)CCLabelAtlas *revenueLabel;
@end


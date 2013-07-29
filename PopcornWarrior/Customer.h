//
//  Customer.h
//  PopcornWarrior
//
//  Created by Matt Sencenbaugh on 7/21/13.
//  Copyright (c) 2013 Matt Sencenbaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"
@class CCSprite, CCLayer, Day;

@protocol CustomerDelegate <NSObject>
@optional
- (void)customerPurchasedSoda;
- (void)customerPurchasedPopcorn;
- (void)customerPurchasedSodaAndPopcorn;
@end

@interface Customer : NSObject

-(id)initWithTag:(NSNumber *)spriteTag withLayer:(CCLayer *)layer withDay:(Day *)day;
@property(nonatomic,strong)NSNumber *spriteTag;
@property(nonatomic, strong)CCSprite *sprite;
@property (nonatomic, assign) id <CustomerDelegate> delegate;

-(void)addToLayer;
-(void)runActionSequence;

+(BOOL)shouldAddCustomerForWeather:(Weather)weather;

@end

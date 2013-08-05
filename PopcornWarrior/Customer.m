//
//  Customer.m
//  PopcornWarrior
//
//  Created by Matt Sencenbaugh on 7/21/13.
//  Copyright (c) 2013 Matt Sencenbaugh. All rights reserved.
//

#import "Customer.h"
#import "cocos2d.h"
#import "Day.h"
#import "Weather.h"

@interface Customer()
{
    CCLayer *_parentLayer;
}
@property(nonatomic,assign)int animationDuration;
@property(nonatomic,strong)NSMutableArray *pendingSprites;
@end


@implementation Customer
@synthesize sprite = _sprite, spriteTag = _spriteTag, animationDuration = _animationDuration, delegate = _delegate;

+(BOOL)shouldAddCustomerForWeather:(Weather *)weather
{
    if (arc4random_uniform(75) % weather.addCustomerRatio == 0) {
        return YES;
    } else {
        return NO;
    }
}

-(id)initWithTag:(NSNumber *)spriteTag withLayer:(CCLayer *)layer withDay:(Day *)day
{
    self = [super init];
    if (self) {
        CCSprite * customerSprite = [CCSprite spriteWithFile:@"boy_large.png"];
        customerSprite.position = ccp(-customerSprite.contentSize.width, 90);
        customerSprite.tag = [spriteTag intValue];
        self.sprite = customerSprite;
        self.spriteTag = spriteTag;
        self.delegate = day;
        self.pendingSprites = [NSMutableArray arrayWithCapacity:3];
        _parentLayer = layer;
    }
    return self;
}

-(void)addToLayer
{
    [_parentLayer addChild:self.sprite];
}

-(void)runActionSequence
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    // Determine speed of the customer
    int minDuration = 5.0;
    int maxDuration = 8.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    self.animationDuration = actualDuration;
    
    // Create the actions
    CCMoveTo * actionMoveHalfway = [CCMoveTo actionWithDuration:actualDuration
                                                       position:ccp(winSize.width/2 - self.sprite.contentSize.width/2, 90)];
    CCCallBlockN *makePurchases = [CCCallBlockN actionWithBlock:^(CCNode *node){
        [self determinePurchases];
    }];
    CCMoveTo *actionFinishWalking = [CCMoveTo actionWithDuration:actualDuration
                                                        position:ccp(winSize.width + self.sprite.contentSize.width/2, 90)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        [self.pendingSprites release];
        [self.sprite release];
        [self release];
        
    }];
    [self.sprite runAction:[CCSequence actions:actionMoveHalfway,makePurchases,actionFinishWalking, actionMoveDone, nil]];
}


-(void)unpauseQueuedNode:(CCNode *)node {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    for (int i = 0; i < self.pendingSprites.count; i++) {
        CCSprite *sprite = [self.pendingSprites objectAtIndex:i];
        [_parentLayer addChild:sprite];
        CCMoveTo *moveWithCustomer = [CCMoveTo actionWithDuration:self.animationDuration
                                                         position:ccp(winSize.width + self.sprite.contentSize.width, 140)];
        CCCallBlockN *removeFromLayer = [CCCallBlockN actionWithBlock:^(CCNode *node) {
            [node removeFromParentAndCleanup:YES];
        }];
        [sprite runAction:[CCSequence actions:moveWithCustomer,removeFromLayer,nil]];
    }
    [node resumeSchedulerAndActions];
    [self.pendingSprites removeAllObjects];
}

-(void)addPopcornSprite
{
    CCSprite *popcornSprite = [CCSprite spriteWithFile:@"popcorn_bubble.png"];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    popcornSprite.position = ccp(winSize.width/2, 140);
    [self.pendingSprites addObject:popcornSprite];
}

-(void)addSodaSprite
{
    CCSprite *popcornSprite = [CCSprite spriteWithFile:@"soda_bubble.png"];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    popcornSprite.position = ccp(winSize.width/2, 140);
    [self.pendingSprites addObject:popcornSprite];
}

-(void)addSodaAndPopcornSprite
{
    CCSprite *popcornSprite = [CCSprite spriteWithFile:@"popcorn_and_soda.png"];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    popcornSprite.position = ccp(winSize.width/2, 140);
    [self.pendingSprites addObject:popcornSprite];
}

-(void)determinePurchases{
    int randomNum = arc4random_uniform(10);
    [self.sprite pauseSchedulerAndActions];
    if (randomNum % 2 == 0 && randomNum % 3 == 0) {
        [self addSodaAndPopcornSprite];
        if ([self.delegate respondsToSelector:@selector(customerPurchasedSodaAndPopcorn)]) {
            [self.delegate customerPurchasedSodaAndPopcorn];
        }
        NSLog(@"Both popcorn and soda purchased");
        [self performSelector:@selector(unpauseQueuedNode:) withObject:self.sprite afterDelay:2.0];
    } else if (randomNum % 2 == 0) {
        NSLog(@"Popcorn bought");
        [self addPopcornSprite];
        if ([self.delegate respondsToSelector:@selector(customerPurchasedPopcorn)]) {
            [self.delegate customerPurchasedPopcorn];
        }
        [self performSelector:@selector(unpauseQueuedNode:) withObject:self.sprite afterDelay:2.0];
    } else if (randomNum %3 == 0) {
        NSLog(@"soda bought");
        [self addSodaSprite];
        if ([self.delegate respondsToSelector:@selector(customerPurchasedSoda)]) {
            [self.delegate customerPurchasedSoda];
        }
        [self performSelector:@selector(unpauseQueuedNode:) withObject:self.sprite afterDelay:2.0];
    } else {
        [self.sprite resumeSchedulerAndActions];
        NSLog(@"Nothing purchased");
    }
}

@end

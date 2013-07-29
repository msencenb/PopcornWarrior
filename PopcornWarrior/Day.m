//
//  Day.m
//  PopcornWarrior
//
//  Created by Matt Sencenbaugh on 7/21/13.
//  Copyright (c) 2013 Matt Sencenbaugh. All rights reserved.
//
#import "GarageSaleLayer.h"
#import "Day.h"

@interface Day()
{
    GarageSaleLayer *_layer;
}
@end

@implementation Day
@synthesize popcornPrice = _popcornPrice, sodaPrice = _sodaPrice, popcornSold = _popcornSold, sodaSold = _sodaSold;

-(id)initWithLayer:(GarageSaleLayer *)layer withPopcornPrice:(NSDecimalNumber *)popcornPrice withSodaPrice:(NSDecimalNumber *)sodaPrice
{
    self = [super init];
    if (self) {
        self.popcornSold = [NSDecimalNumber zero];
        self.sodaSold = [NSDecimalNumber zero];
        self.sodaPrice = sodaPrice;
        self.popcornPrice = popcornPrice;
        _layer = layer;
    }
    return self;
}

-(NSDecimalNumber *)revenue
{
    NSDecimalNumber *popcornRevenue = [self.popcornSold decimalNumberByMultiplyingBy:self.popcornPrice];
    NSDecimalNumber *sodaRevenue = [self.sodaSold decimalNumberByMultiplyingBy:self.sodaPrice];
    
    return [sodaRevenue decimalNumberByAdding:popcornRevenue];
}

//I need to have random events during each 'week' that make supplies disappear so that players try to keep things close to their chest.
-(NSString *)stringForDecimalNumber:(NSDecimalNumber *)number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    return [formatter stringFromNumber:number];
}

-(void)setRevenueLabel
{
    NSLog(@"soda price %@",[self.sodaPrice stringValue]);
    NSLog(@"popcorn price %@",[self.popcornPrice stringValue]);
    NSDecimalNumber *popcornRevenue = [self.popcornPrice decimalNumberByMultiplyingBy:self.popcornSold];
    NSDecimalNumber *sodaRevenue = [self.sodaPrice decimalNumberByMultiplyingBy:self.sodaSold];
    NSDecimalNumber *total = [popcornRevenue decimalNumberByAdding:sodaRevenue];
    [_layer.revenueLabel setString:[self stringForDecimalNumber:total]];
}

#pragma mark customer delegate events
- (void)customerPurchasedSoda
{
    self.sodaSold = [self.sodaSold decimalNumberByAdding:[NSDecimalNumber one]];
    [_layer.sodaLabel setString:[self.sodaSold stringValue]];
    [self setRevenueLabel];
}

- (void)customerPurchasedPopcorn
{
    self.popcornSold = [self.popcornSold decimalNumberByAdding:[NSDecimalNumber one]];
    [_layer.popcornLabel setString:[self.popcornSold stringValue]];
    [self setRevenueLabel];
    
}

- (void)customerPurchasedSodaAndPopcorn
{
    [self customerPurchasedPopcorn];
    [self customerPurchasedSoda];
}
@end

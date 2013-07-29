//
//  GarageSaleLayer.m
//  PopcornWarrior
//
//  Created by Matt Sencenbaugh on 7/16/13.
//  Copyright 2013 Matt Sencenbaugh. All rights reserved.
//

//Weather modifies the modulo with sunny and blistering being 2
//Others progressively worse

//Probably want classes for weather that spit out background sprite plus modifiers
//Random dice roll to determine weather
//Each state has a modifier for weather more soda or popcorn was sold

//There is a time limit each day, real time counter of supplies and profit in the corner
//Fast forward button doubles the interval time (I assume I can cancel the interval in the loop on a button touch)
#ifndef CC_GARAGE_SALE_STATS_POSITION
#define CC_DIRECTOR_STATS_POSITION ccp(0,270)
#endif


#import "GarageSaleLayer.h"
#import "Customer.h"
#import "Weather.h"
#import "EndOfDayLayer.h"
#import "Day.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

@interface GarageSaleLayer ()
{
    int _currentWeather;
    int _tagCount;
    int _currentHour;
}
@property(nonatomic,strong)Day *day;
@property(nonatomic,strong)CCLabelTTF *clock;
@end

@implementation GarageSaleLayer
@synthesize day = _day, popcornLabel = _popcornLabel, sodaLabel = _sodaLabel, revenueLabel = _revenueLabel, clock = _clock;
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *)sceneWithPopcornPrice:(NSDecimalNumber *)popcornPrice withSodaPrice:(NSDecimalNumber *)sodaPrice
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GarageSaleLayer *layer = [GarageSaleLayer nodeWithPopcornPrice:popcornPrice withSodaPrice:sodaPrice];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void)getFPSImageData:(unsigned char**)datapointer length:(NSUInteger*)len
{
	*datapointer = cc_fps_images_png;
	*len = cc_fps_images_len();
}

-(void)createDailyStatusLabels
{
	CCTexture2D *texture;
	CCTextureCache *textureCache = [CCTextureCache sharedTextureCache];
	
	if( _sodaLabel && _revenueLabel ) {
        
		[_sodaLabel release];
		[_revenueLabel release];
		[_popcornLabel release];
		[textureCache removeTextureForKey:@"cc_fps_images"];
		_sodaLabel = nil;
		_popcornLabel = nil;
		_revenueLabel= nil;
		
		[[CCFileUtils sharedFileUtils] purgeCachedEntries];
	}
    
	CCTexture2DPixelFormat currentFormat = [CCTexture2D defaultAlphaPixelFormat];
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
	unsigned char *data;
	NSUInteger data_len;
	[self getFPSImageData:&data length:&data_len];
	
	NSData *nsdata = [NSData dataWithBytes:data length:data_len];
	CGDataProviderRef imgDataProvider = CGDataProviderCreateWithCFData( (CFDataRef) nsdata);
	CGImageRef imageRef = CGImageCreateWithPNGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
	texture = [textureCache addCGImage:imageRef forKey:@"cc_fps_images"];
	CGDataProviderRelease(imgDataProvider);
	CGImageRelease(imageRef);
    
	_sodaLabel = [[CCLabelAtlas alloc]  initWithString:@"0" texture:texture itemWidth:12 itemHeight:32 startCharMap:'.'];
	_popcornLabel = [[CCLabelAtlas alloc]  initWithString:@"0" texture:texture itemWidth:12 itemHeight:32 startCharMap:'.'];
	_revenueLabel = [[CCLabelAtlas alloc]  initWithString:@"0.00" texture:texture itemWidth:12 itemHeight:32 startCharMap:'.'];
    CCLabelTTF *label = [[[CCLabelTTF alloc] initWithString:@"$" fontName:@"Helvetica" fontSize:14.0] autorelease];;
    [label setPosition: ccpAdd(ccp(5,8),CC_DIRECTOR_STATS_POSITION)];
    [self addChild:label];
    
	[CCTexture2D setDefaultAlphaPixelFormat:currentFormat];
    
	[_sodaLabel setPosition: ccpAdd( ccp(0,34), CC_DIRECTOR_STATS_POSITION ) ];
	[_popcornLabel setPosition: ccpAdd( ccp(0,17), CC_DIRECTOR_STATS_POSITION ) ];
	[_revenueLabel setPosition: ccpAdd( ccp(15,-1), CC_DIRECTOR_STATS_POSITION)];
    
    [self addChild:_sodaLabel];
    [self addChild:_popcornLabel];
    [self addChild:_revenueLabel];
}

-(void)addWeather:(Weather)weather
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSprite *sprite = nil;
    _currentWeather = weather;
    switch (weather) {
        case 0:
            NSLog(@"Sunny day");
            sprite = [CCSprite spriteWithFile:@"blue_background.png"];
            break;
            
        default:
            break;
    }
    sprite.position = ccp(size.width/2,size.height/2);
    [self addChild:sprite];
}

-(void)addSceneryAndMe
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSprite *mainSprite = [CCSprite spriteWithFile:@"main_scene.png"];
    mainSprite.position = ccp(size.width/2, size.height/2 + 40);
    [self addChild:mainSprite];
}

-(void)addClock{
    CGSize size = [[CCDirector sharedDirector] winSize];
    _currentHour = 9;
    self.clock = [[[CCLabelTTF alloc] initWithString:@"9:00 AM" fontName:@"Helvetica" fontSize:14.0] autorelease];;
    [self.clock setPosition: ccp(size.width-30,size.height-10)];
    [self addChild:self.clock];
    
}

+(id)nodeWithPopcornPrice:(NSDecimalNumber *)popcornPrice withSodaPrice:(NSDecimalNumber *)sodaPrice
{
    return [[[GarageSaleLayer alloc] initWithPopcornPrice:popcornPrice withSodaPrice:sodaPrice] autorelease];
}



// on "init" you need to initialize your instance
-(id) initWithPopcornPrice:(NSDecimalNumber *)popcornPrice withSodaPrice:(NSDecimalNumber *)sodaPrice
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        _tagCount = 0;
        _day = [[Day alloc] initWithLayer:self withPopcornPrice:popcornPrice withSodaPrice:sodaPrice];
        [self addWeather:kSunny];
        [self addSceneryAndMe];
        [self createDailyStatusLabels];
        [self addClock];
        
        [self schedule:@selector(addCustomer:) interval:0.5];
        [self schedule:@selector(incrementHourInDay:) interval:5.0];
    }
    return self;
}

-(void)checkIfAllCustomersFinished
{ 
    if ([self.children count] == 7) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[EndOfDayLayer sceneWithCompletedDay:self.day]]];
    }
}

-(void)incrementHourInDay:(ccTime)dt {
    _currentHour++;
    if (_currentHour == 18) {
        NSLog(@"Finished day");
        [self unscheduleAllSelectors];
        [self schedule:@selector(checkIfAllCustomersFinished) interval:1.0];
        return;
    }
    NSString *time = nil;
    if (_currentHour <= 12) {
        time = [NSString stringWithFormat:@"%d:00 AM",_currentHour];
    } else {
        time = [NSString stringWithFormat:@"%d:00 PM",_currentHour-12];
    }
    [self.clock setString:time];
}

- (void)addCustomer:(ccTime)dt {
    if ([Customer shouldAddCustomerForWeather:_currentWeather]) {
        
        Customer *customer = [[Customer alloc] initWithTag:[[NSNumber numberWithInt:_tagCount] autorelease] withLayer:self withDay:self.day];
        _tagCount++;

        
        [customer addToLayer];
        [customer runActionSequence];
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [self.revenueLabel release];
    [self.sodaLabel release];
    [self.popcornLabel release];
	[super dealloc];
}

@end

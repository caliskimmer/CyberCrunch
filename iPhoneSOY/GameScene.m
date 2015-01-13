//
//  GameScene.m
//  iPhoneSOY
//
//  Created by Matas Empakeris on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "BackgroundLayer.h"
#import "GameLayer.h"

@implementation GameScene

-(id) init
{
    if( self = [super init] )
    {
        bLayer = [BackgroundLayer node];
        gLayer = [GameLayer node];
        
        [self addChild: bLayer z: 0];
        [self addChild: gLayer z: 1];
    } //end if
    
    return self;
}


@end

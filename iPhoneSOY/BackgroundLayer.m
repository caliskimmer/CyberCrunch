//
//  BackgroundLayer.m
//  iPhoneSOY
//
//  Created by Matas Empakeris on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer


-(id) init
{
    if( self = [super init] )
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        background = [CCSprite spriteWithFile: @"CyberCrunch_iPhone.png" ];
        
        background.position = ccp( size.width/2, size.height/2);
        
        [self addChild: background];
    } //end if
    
    return self;
}

-(void)dealloc
{
} //end dealloc

@end

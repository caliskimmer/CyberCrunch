//
//  MenuScene.m
//  iPhoneSOY
//
//  Created by Matas Empakeris on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "MenuLayer.h"

@implementation MenuScene

-(id)init
{
    if( self = [super init] )
    {
        menu = [MenuLayer node];
        [self addChild: menu z: 0];
    } //end if
    
    return self;
}

@end

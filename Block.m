//
//  Block.m
//  iPhoneSOY
//
//  Created by Matas Empakeris on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Block.h"

@implementation Block
@synthesize blockColor;

-(id)initWithColorStyle:(Color)color
{
    if( self = [super init] )
    {
        if( color == BLUE )
        {
            self.blockColor = BLUE;
            [self initWithFile: @"Block_BLUE_iPhone.png"];
        } //end else if
        
        else if( color == GREEN )
        {
            self.blockColor = GREEN;
            [self initWithFile: @"Block_GREEN_iPhone.png"];
        } //end else if
        
        else if( color == RED )
        {
            self.blockColor = RED;
            [self initWithFile: @"Block_RED_iPhone.png"];
        } //end else if
        
        else if( color == GOLD )
        {
            self.blockColor = GOLD;
            [self initWithFile: @"Block_CYBERCOIN_iPhone.png"];
        } //end else if
    } //end if
    
    return self;
} //end initWithColor

-(int)xPosition:(int)column
{
    return 20 + ( column * X_PADDING );
} //end xPosition

-(int)yPosition:(int)row initialRow:(BOOL)initBar
{
    if( !initBar )
    {
        return 80 + ( row * 25 );
    } //end if
    
    else
    {
        return INIT_ROW;
    } //end else
} //end yPosition

@end

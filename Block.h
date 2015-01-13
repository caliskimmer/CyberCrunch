//
//  Block.h
//  iPhoneSOY
//
//  Created by Matas Empakeris on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#define X_PADDING 25
#define INIT_ROW 21

//This enum is in C Format and defines constants to use as Color arguments in "initWithColor"
typedef enum
{
    BLUE,
    GREEN,
    RED,
    GOLD
}Color;

@interface Block : CCSprite
{
    Color blockColor;
}

@property (readwrite) Color blockColor;

//Constructor to create a block with a certain color
-(id)initWithColorStyle:(Color)color;
-(int)xPosition:(int)column;
-(int)yPosition:(int)row initialRow:(BOOL)initBar;

@end

//
//  GameLayer.h
//  iPhoneSOY
//
//  Created by Matas Empakeris on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#define MAX_HEIGHT 16
#define MAX_WIDTH 9

@class Block;
@interface GameLayer : CCLayer
{
    
@private
    Block* block;
    int row;
    int column;
    int randColor; //random color of the block
    int score;
    int levelUp;
    int level;
    int preliminaryCounter;
    float speed;
    BOOL isIncreasingSpeed;
    BOOL startGame;
    
    CCLabelBMFont *countDown;
    CCLabelBMFont* scoreLabel;
    CCLabelBMFont* levelLabel;
    NSMutableArray *initRow;
    NSMutableSet *subFoundBlocks;
    Block* gameGrid[ MAX_HEIGHT ][MAX_WIDTH];
    
    CGPoint location;
} //end interface declaration

-(void)addBlock:(ccTime)dt;
-(void)preliminaryCountdown:(ccTime)dt;
-(void)findBlockNeighborsOfRow:(int)r Column:(int)c;
-(void)specialRemove;
-(void)collapseBlocks;
-(BOOL)isGameOver;
@end

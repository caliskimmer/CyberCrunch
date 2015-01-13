//
//  GameLayer.m
//  iPhoneSOY
//
//  Created by Matas Empakeris on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "Block.h"
#import "CCTouchHandler.h"
#import "MenuScene.h"

@implementation GameLayer

-(id) init
{
    if( self = [super init] )
    {
        self.isTouchEnabled = YES;
        CGSize size = [[CCDirector sharedDirector] winSize];
        score = 0;
        level = 1;
        levelUp = 50;
        speed = .4f;
        preliminaryCounter = 3;
        isIncreasingSpeed = NO;
        startGame = NO;
        
        column = 0;
        row = (int) MAX_HEIGHT/3;
        
        scoreLabel = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @"%i", score] fntFile: @"konqa32.fnt"];
        scoreLabel.position = ccp( 283, 321 );
        [(CCSprite *)scoreLabel setScale: .75];
        
        levelLabel = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @"%i", level] fntFile: @"konqa32.fnt"];
        levelLabel.position = ccp( 283, 200 );
        [(CCSprite *)levelLabel setScale: .75];
        
        countDown = [CCLabelBMFont labelWithString: @"Ready?" fntFile:@"konqa32.fnt"];
        countDown.position = ccp( size.width/2 - 35, size.height/2 );
        
        initRow = [[ NSMutableArray alloc ] init];
        subFoundBlocks = [[NSMutableSet alloc] init];
        
        for( int r = 0; r < (int) MAX_HEIGHT/3; r++ )
        {
            for( int c = 0; c < MAX_WIDTH; c++ )
            {
                randColor = arc4random() % 3;
                gameGrid[ r ][ c ] = [[Block alloc] initWithColorStyle:(Color) randColor];
                gameGrid[ r ][ c ].position = ccp( [gameGrid[ r ][ c ] xPosition: c ], [gameGrid[ r ][ c ] yPosition: r initialRow: NO] );
                
                [self addChild: gameGrid[ r ][ c ]];
            } //end nested for
        } //end for
        
        [self addChild: countDown];
        [self addChild: scoreLabel];
        [self addChild: levelLabel];
    } //end else
    
    return self;
}


-(void)addBlock: (ccTime )dt
{
    //Chance algorithm: States that if gold is picked as a random number, then a random number out of 50 is picked. If the number is 17, a gold block is dropped. Otherwise, a random regular block is picked.
    if( level > 6 )
    {
        randColor = arc4random() % 4;
        
        if( randColor == 3 )
        {
            int chance = arc4random() % 51;
            
            if( chance != 17 )
            {
                randColor = arc4random() % 3;
            } //end if
        } //end if
    } //end if
    
    else
    {
        randColor = arc4random() % 3;
    } //end else
    
    if( isIncreasingSpeed == YES )
    {
        if( !((speed - 0.05f) < 0.0f ) )
        {
            speed = speed - 0.0f;
        } //end if
        
        [self unschedule: @selector(addBlock:)];
        [self schedule: @selector( addBlock: ) interval: speed];
        isIncreasingSpeed = NO;
    } //end if
    
    if( [self isGameOver] )
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipY transitionWithDuration:1.0f scene:[MenuScene node]]];
    } //end if

    if( column < MAX_WIDTH )
    {
        [initRow insertObject: [[Block alloc] initWithColorStyle:(Color)randColor] atIndex: column];
        block = [initRow objectAtIndex: column];
        
        block.position = ccp( [block xPosition: column], [block yPosition: row initialRow: YES] );
            
        [self addChild: block];
            
        column++;
    } //end if
    
    if( column == MAX_WIDTH )
    {
        for( int r = row - 1; r >= 0; r-- )
        {
            for( int c = 0; c < MAX_WIDTH; c++ )
            {
                /***********************************************************/
                if( !gameGrid[ r+1 ][ c ] && gameGrid[r][c] != nil )
                {
                    gameGrid[ r+1 ][ c ] = gameGrid[ r ][ c ];
                } //end if
                /***********************************************************/
                gameGrid[ r ][ c ] = nil;
                gameGrid[ r+1 ][ c ].position = ccp( [gameGrid[ r+1 ][ c ] xPosition: c], [gameGrid[ r+1 ][ c ] yPosition: r+1 initialRow: NO] );
            } //end nested for
        } //end for
            
        for( int index = 0; index < MAX_WIDTH; index++ )
        {
            gameGrid[ 0 ][ index ] = [initRow objectAtIndex: index];
            gameGrid[ 0 ][ index ].position = ccp( [gameGrid[ 0 ][ index ] xPosition: index], [gameGrid[ 0 ][ index ] yPosition: 0 initialRow: NO] );
        } //end for
            
        column = 0;
        row++;
    } //end if
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    location = [touch locationInView: touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    location = [self convertToNodeSpace: location];
    
    CGPoint touchedPosition = ccp( location.x , location.y );
    
    if( startGame == NO )
    {
        [self schedule: @selector(preliminaryCountdown:) interval: 1];
    } //end if
    
	 else
	 {
		 for( int r = 0; r < MAX_HEIGHT; r++ )
		 {
			  for( int c = 0; c < MAX_WIDTH; c++ )
			  {
					if( gameGrid[r][c] != nil )
					{
						 row = r + 1;
					} //end if
			  } //end nested for
		 } //end for
		 
		 for( int r = 0; r < row; r++ )
		 {
			  for( int c = 0; c < MAX_WIDTH; c++ )
			  {
                    if( CGRectContainsPoint( [gameGrid[ r ][ c ] boundingBox], touchedPosition ) && gameGrid[r][c] != nil && gameGrid[r][c].blockColor == GOLD)
                    {
                        [self specialRemove];
                        [subFoundBlocks addObject: gameGrid[r][c]];
                    } //end if
                  
					else if( CGRectContainsPoint( [gameGrid[ r ][ c ] boundingBox], touchedPosition ) && gameGrid[r][c] != nil)
					{
						 [self findBlockNeighborsOfRow:r Column:c];
					} //end if
			  } //end nested for
		 } //end for
		 
		 
		 if( [subFoundBlocks count] >= 3 )
		 {
			  [self collapseBlocks];
				score += [subFoundBlocks count];
		 } //end if
		 
		 [scoreLabel setString: [NSString stringWithFormat:@"%i", score]];
		 
		 if( score > levelUp )
		 {
			  level++;
			  [levelLabel setString: [NSString stringWithFormat:@"%i", level]];
			  levelUp += 50;
			  isIncreasingSpeed = YES;
		 } //end if

		 [subFoundBlocks removeAllObjects];
	 } //end else
    
    return YES;
} //end ccTouchBegan

- (void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)findBlockNeighborsOfRow:(int)r Column:(int)c
{
    
    if( ![subFoundBlocks containsObject: gameGrid[r][c]] )
    {
        //NSLog( @"Added ROW: %i COLUMN: %i", r, c );
        [subFoundBlocks addObject: gameGrid[r][c]];
    } //end if
    
    if( (r+1) < row && ![subFoundBlocks containsObject: gameGrid[r+1][c]] && gameGrid[r+1][c] != nil && gameGrid[r+1][c].blockColor == gameGrid[r][c].blockColor)
    {
        [self findBlockNeighborsOfRow: r+1 Column: c];
    } //end if
    
    if( (r-1) >= 0 && gameGrid[r-1][c] != nil && ![subFoundBlocks containsObject:gameGrid[r-1][c]] && gameGrid[r-1][c].blockColor == gameGrid[r][c].blockColor )
    {
        [self findBlockNeighborsOfRow: r-1 Column: c];
    } //end if
    
    if( (c+1) < MAX_WIDTH && gameGrid[r][c+1] != nil && ![subFoundBlocks containsObject: gameGrid[r][c+1]] && gameGrid[r][c].blockColor == gameGrid[r][c+1].blockColor )
    {
        [self findBlockNeighborsOfRow: r Column: c+1];
    } //end if
    
    if( (c-1) >= 0 && gameGrid[r][c-1] != nil && ![subFoundBlocks containsObject: gameGrid[r][c-1]] && gameGrid[r][c].blockColor == gameGrid[r][c-1].blockColor )
    {
        [self findBlockNeighborsOfRow: r Column: c-1];
    } //end if
} //end findBlockNeighbors

-(void)specialRemove
{
    int tempColor = arc4random()%4;
    
    for( int r = 0; r < row; r++ )
    {
        for( int c = 0; c < MAX_WIDTH; c++ )
        {
            if( gameGrid[r][c].blockColor == tempColor )
            {
                [subFoundBlocks addObject: gameGrid[r][c]];
            } //end if
        } //end for
    } //end for
} //end specialRemove

-(void)collapseBlocks
{
    /*This for-for checks for if the blocks in the NSMutableSet are equal to any of the blocks on the grid.
     If so, then it sets them to nil and sets alpha to 0 in order to have them become invisible to 
     prevent user confusion*/
    
    for( int r = 0; r < row; r++ )
    {
        for( int c = 0; c < MAX_WIDTH; c++ )
        {
           if( [subFoundBlocks containsObject: gameGrid[r][c]] )
           {
               [gameGrid[r][c] runAction: [CCActionTween actionWithDuration:1.0 key:@"scaleX" from:1.0 to:-1.0]];
               [gameGrid[r][c] runAction: [CCFadeTo actionWithDuration:.5f opacity:0.0f]];
               gameGrid[r][c] = nil;
           } //end if
        } //end for
    } //end for
    
    /*This for-for combination performs vertical consolidation. It first creates a temporary variable and
     in a while loop, checks to see if the block slot below is nil before moving it down. This process repeats
     until the statement is no longer true.*/
    
    for( int r = 1; r < row; r++ )
    {
        for( int c = 0; c < MAX_WIDTH; c++ )
        {
            int tempRow = r;
            
            while( gameGrid[tempRow][c] != nil && gameGrid[tempRow-1][c] == nil && tempRow > 0 )
            {
                gameGrid[tempRow-1][c] = gameGrid[tempRow][c];
                gameGrid[tempRow][c] = nil;
                
                gameGrid[tempRow-1][c].position = ccp( [gameGrid[tempRow-1][c] xPosition: c], [gameGrid[tempRow-1][c] yPosition: tempRow-1 initialRow: NO] );
                tempRow--;
            } //end if
        } //end nested for
    } //end for
    
    /*This algorithm performs horizontal consolidation. First, it checks for how many blocks are in each row. Next it keeps moving the blocks over until it
     hits another non-nil column.*/

   for( int c = 0; c < MAX_WIDTH; c++ )
    {
        if( (c-1) >= 0 && gameGrid[0][c] != nil )
        {
            int tempCol = c;
            int tempRowPerColumn = 0;
            
            while( gameGrid[0][tempCol-1] == nil )
            {
                while( gameGrid[tempRowPerColumn][c] != nil )
                {
                    tempRowPerColumn++;
                } //end while
                
               for( int r = 0; r < tempRowPerColumn; r++ )
               {
                   gameGrid[r][tempCol-1] = gameGrid[r][tempCol];
                   gameGrid[r][tempCol] = nil;
                   
                   gameGrid[r][tempCol - 1].position = ccp( [gameGrid[r][tempCol-1] xPosition: tempCol-1], [gameGrid[r][tempCol-1] yPosition:r initialRow: NO] );
               } //end for
                
                tempCol--;
           } //end while
        } //end if
    } //end for
} //end collapseBlocks

-(BOOL)isGameOver
{
    if( row == MAX_HEIGHT )
    {
        [[CCTouchDispatcher sharedDispatcher] setDispatchEvents: NO];
        [self unschedule: @selector(addBlock:)];
        return YES;
    } //end if
    
    return NO;
} //end gameOver
                                  
-(void)preliminaryCountdown:(ccTime)dt
{
    [countDown setString: [NSString stringWithFormat: @"%i", preliminaryCounter]];
    preliminaryCounter--;
    
    if( preliminaryCounter < 0 )
    {
        [self unschedule: @selector(preliminaryCountdown:)];
        [countDown setString: @"Go!"];
        [(CCSprite *)countDown runAction: [CCFadeTo actionWithDuration: 1.0f opacity: 0.0f]];
        [self schedule: @selector( addBlock: ) interval: speed ];
		  startGame = YES;
    } //end if
} //end preliminaryCountdown

-(void)dealloc
{
    [subFoundBlocks release];
    subFoundBlocks = nil;
    
    [scoreLabel release];
    scoreLabel = nil;
    
    [levelLabel release];
    levelLabel = nil;
    
    [countDown release];
    countDown = nil;
	
	[block release];
	block = nil;

    for( int r = 0; r < MAX_HEIGHT; r++ )
    {
        for( int c = 0; c < MAX_WIDTH; c++ )
        {
            if( gameGrid[ r ][ c ] != nil )
            {
                [gameGrid[ r ][ c ] release];
                gameGrid[r][c] = nil;
            } //end if
        } //end nested for
    } //end for
    
    for( int index = 0; index < MAX_WIDTH; index++ )
    {
        if( [initRow objectAtIndex: index] != nil )
        {
            [[initRow objectAtIndex: index] release];
        } //end if
    } //end for
    
    [initRow release];
    initRow = nil;
    
    //[super dealloc];
} //end dealloc

@end

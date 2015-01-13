//
//  MenuLayer.m
//  iPhoneSOY
//
//  Created by Matas Empakeris on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "GameScene.h"
#import "Block.h"

@implementation MenuLayer
@synthesize playButton = _playButton;
@synthesize gameLogo;
@synthesize fadeOutAction = _fadeOutAction, fadeInAction = _fadeInAction;
@synthesize blockArray = _blockArray;

-(id)init
{
    if( self = [super init] )
    {
        blockNum = 0;
        size = [[CCDirector sharedDirector] winSize];
		fadeInAction = [CCFadeOut actionWithDuration: 1.0f];
		fadeOutAction = [CCFadeIn actionWithDuration: 1.0f];
        blockArray = [[NSMutableArray alloc] init];
		 
        menuBackground = [CCSprite spriteWithFile: @"Menu_Background_iPhone.png" ];
        
        menuBackground.position = ccp( size.width/2, size.height/2);
        
		[self addChild: menuBackground z: 0];
        
		playButton = [CCMenuItemImage itemFromNormalImage:@"Generic_Button_iPhone.png" selectedImage:@"Generic_Button_Selected_iPhone.png" target: self selector: @selector( playPressed )];
		
		gameLogo = [CCSprite spriteWithFile: @"Cyber_Crunch_Logo.png"];
		gameLogo.position = ccp( size.width/2, size.height - 100 );
		[self addChild: gameLogo z: 2];
		[gameLogo runAction: [CCSequence actions: fadeInAction, fadeOutAction, nil]];
        
        menu = [CCMenu menuWithItems: playButton, nil];
        [menu alignItemsVertically];
        
        [self schedule:@selector(addBlock:) interval: 1.0f];
        [self schedule:@selector(scroll:) interval: 1/60];
        
        [self addChild:menu z: 3];
    } //end if
    
    return self;
}
-(void)scroll:(ccTime)dt
{
    for( Block* block in blockArray )
    {
        block.position = ccp( block.position.x, block.position.y - 1 );
        
        if( block.position.y < -25 )
        {
            block.position = ccp( (arc4random() % (int) size.width), size.height + 10);
        } //end if
    } //end for
}//end scroll

-(void)addBlock:(ccTime)dt
{
    if( blockNum < 9 )
    {
        //Memory management is difficult...
        
        [blockArray addObject: [[[Block alloc] initWithColorStyle: (arc4random()%4)] retain]];
        [[blockArray objectAtIndex: blockNum] setPosition: ccp( (arc4random() % (int) size.width), size.height + 10)];
        [self addChild: [blockArray objectAtIndex:blockNum] z: 1];
        blockNum++;
    } //end if
} //end scroll

-(void)playPressed
{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFlipX transitionWithDuration: 1.0f scene: [GameScene node]]];
} //end playPressed

-(void)dealloc
{
    //need to set to nil!
    for( int index = 0; index < [blockArray count]; index++ )
    {
        NSLog( @"%i", [blockArray count] );
        [[blockArray objectAtIndex: index] release];
    } //end for
    
    [blockArray release];
    [super dealloc];
} //end dealloc
@end

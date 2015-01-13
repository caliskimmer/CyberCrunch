//
//  MenuLayer.h
//  iPhoneSOY
//
//  Created by Matas Empakeris on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface MenuLayer : CCLayer
{
    @private
    CCSprite* menuBackground;
    CGSize size;
    CCMenu *menu;
    CCMenuItem* playButton;
    CCSprite* gameLogo;
    NSMutableArray* blockArray;
    id fadeOutAction;
    id fadeInAction;
    
    int blockNum;
}

@property(nonatomic, retain) CCMenuItem *playButton;
@property(nonatomic, retain) CCSprite *gameLogo;
@property(nonatomic, retain) id fadeOutAction;
@property(nonatomic, retain) id fadeInAction;
@property(nonatomic, retain) NSMutableArray* blockArray;

-(void)playPressed;
-(void)scroll:(ccTime)dt;
-(void)addBlock:(ccTime)dt;

@end

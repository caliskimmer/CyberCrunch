//
//  GameScene.h
//  iPhoneSOY
//
//  Created by Matas Empakeris on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@class BackgroundLayer;
@class GameLayer;

@interface GameScene : CCScene
{
    
@private
    BackgroundLayer* bLayer;
    GameLayer* gLayer;
}

@end

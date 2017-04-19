//
//  GameRules.h
//  KataBowling-Challenge
//
//  Created by Ravi Patel on 4/3/17.
//  Copyright © 2017 Jay Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScoreBoard.h"

@protocol GameRules_Delegates <NSObject>

@required
-(void)createNewFrameToScoreBoard:(Frame *)frame ;
-(void)updateScoreBoard:(NSInteger)score ;
@end

@interface GameRules : NSObject

@property (weak,nonatomic) id<GameRules_Delegates> delegate ;

@end


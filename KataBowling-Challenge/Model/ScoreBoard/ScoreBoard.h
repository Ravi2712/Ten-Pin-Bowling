//
//  ScoreBoard.h
//  KataBowling-Challenge
//
//  Created by Ravi Patel on 4/2/17.
//  Copyright © 2017 Jay Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Frame.h"

@interface ScoreBoard : NSObject

@property (assign) NSInteger totalScore ;

@property (strong,nonatomic) Frame *currentFrame ;
@property (strong,nonatomic) NSMutableArray<Frame *> *framesArray ;

-(void)printScoreBoard ;

@end

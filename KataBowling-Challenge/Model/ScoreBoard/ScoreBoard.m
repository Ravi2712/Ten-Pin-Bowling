//
//  ScoreBoard.m
//  KataBowling-Challenge
//
//  Created by Ravi Patel on 4/2/17.
//  Copyright © 2017 Jay Patel. All rights reserved.
//

#import "ScoreBoard.h"
#import "GameRules.h"

@interface ScoreBoard() <GameRules_Delegates>

@property (strong,nonatomic) GameRules *gameRulesObject ;

@end

@implementation ScoreBoard

@synthesize  currentFrame = _currentFrame , framesArray = _framesArray ;

-(id)init
{
    self = [super init];
    
    if (self) {
    
        _framesArray = [[NSMutableArray alloc] init] ;
         
         // Set GameRules Delegate
        
        _gameRulesObject = [[GameRules alloc] init] ;
        _gameRulesObject.delegate = self ;
    }
    
    return self;
}


#pragma mark - GAME RULES Delegates


-(void)createNewFrameToScoreBoard:(Frame *)frame
{
    // Create New Frame
    _currentFrame = frame ;
    
    // Add frame to scoreboard
    [_framesArray addObject:frame] ;
}

-(void)updateScoreBoard:(NSInteger)score
{    
    self.totalScore += score ;
}


#pragma mark - Print Score Board

-(void)printScoreBoard
{
    NSMutableArray *frmArray = [[NSMutableArray alloc] init] ;
    
    for (int i = 0 ; i < self.framesArray.count; i++) {
        
        Frame *fr = [self.framesArray objectAtIndex:i] ;
        
        NSMutableArray *rollArr = [[NSMutableArray alloc] init] ;
        for (int j = 0 ; j < fr.rollsArray.count; j++) {
            
            Roll *rl = [fr.rollsArray objectAtIndex:j] ;
            [rollArr addObject:rl.rollValue] ;
        }
        
        [frmArray addObject:rollArr] ;
    }
    
    NSLog(@"%@" , frmArray) ;
}


@end

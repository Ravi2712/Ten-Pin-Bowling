//
//  Player.m
//  KataBowling-Challenge
//
//  Created by Ravi Patel on 4/2/17.
//  Copyright © 2017 Jay Patel. All rights reserved.
//

#import "Player.h"

@interface Player()

@end

@implementation Player

-(id)initWithPlayerName:(NSString *)name scoreBoard:(ScoreBoard *)board
{
    self = [super init] ;
    
    if(self) {
        _playerName = name ;
        _scoreBoard = board ;
    }
    
    return  self ;
}

-(void)rollTheBall:(NSString *)str
{    
    Roll *roll = [[Roll alloc] initWithRoll:str] ;
    [roll handleRollAction] ;
    
}

@end

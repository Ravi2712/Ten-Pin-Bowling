//
//  Player.h
//  KataBowling-Challenge
//
//  Created by Ravi Patel on 4/2/17.
//  Copyright © 2017 Jay Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScoreBoard.h"

@interface Player : NSObject

@property (strong,nonatomic) NSString *playerName ;
@property (strong,nonatomic) ScoreBoard *scoreBoard ;

-(id)initWithPlayerName:(NSString *)name scoreBoard:(ScoreBoard *)board ;


/*
 
 Action :- Player Roll the Ball
 
*/

-(void)rollTheBall:(NSString *)str ;

@end

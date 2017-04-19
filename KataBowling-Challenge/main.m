//
//  main.m
//  KataBowling-Challenge
//
//  Created by Ravi Patel on 4/2/17.
//  Copyright © 2017 Jay Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "ScoreBoard.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        // Game from "Alex"
        
        ScoreBoard *board = [[ScoreBoard alloc] init] ;
        Player *player = [[Player alloc] initWithPlayerName:@"Alex" scoreBoard:board] ;
        
        
        // Test case - 1
        
        NSString *rollsOfAlex = @"7/21216/12124/321321" ;
    
        NSInteger strLength = rollsOfAlex.length ;
        
        for(int i = 0 ; i < strLength ; i++) {
            
            char c = [rollsOfAlex characterAtIndex:i] ;
            NSString *str = [NSString stringWithFormat:@"%c", c] ;
        
            [player rollTheBall:str] ;
        }
        
        // -----------
        // Print Scoreboard
        // -----------
        
        [board printScoreBoard] ;
        
        
        // -----------
        // Display Final Score
        // -----------
        
        NSLog(@"\n// ----------- \n// Player : %@ \n// Final Score : %ld \n// -----------", player.playerName , (long)board.totalScore) ;
    }
    
    return 0;
}


/* 
 
 
 TEST CASES
 

 
 // Test case - 2
 
 rollsOfAlex = @"5/5/5/5/5/5/5/5/5/5/5" ;
 
 
 // Test case - 3
 
 rollsOfAlex = @"9-9-9-9-9-9-9-9-9-9-" ;
 
 
 // Test case - 4
 
 rollsOfAlex = @"XXXXXXXXXXXX" ;
 
 
 // Test case - 5
 
 rollsOfAlex = @"8/8172635/7/819-7281" ;
 
 
 // Test case - 6
 
 rollsOfAlex = @"XXX6/321/X9/--4/5" ;
 
 
 // Test case - 7
 
 rollsOfAlex = @"23265/5/32XX9/2343" ;
 
 
 // Test case - 8
 
 rollsOfAlex = @"11XXXXX5/X8/1-" ;
 
 
 // Test case - 9
 
 rollsOfAlex = @"X119/9/71XX7/6/X4-" ;
 
 
 // Test case - 10
 
 rollsOfAlex = @"52335372716261815281" ;
 
 
 // Test case - 11
 
 rollsOfAlex = @"--------------------" ;
 
 
 */


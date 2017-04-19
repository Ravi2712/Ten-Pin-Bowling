//
//  Roll.h
//  KataBowling-Challenge
//
//  Created by Ravi Patel on 4/2/17.
//  Copyright © 2017 Jay Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Roll : NSObject

@property (strong,nonatomic) NSString *rollValue ;

-(id)initWithRoll:(NSString *)str ;


/*
 
 Action :- Handle Roll Action
 
*/

-(void)handleRollAction ;

@end

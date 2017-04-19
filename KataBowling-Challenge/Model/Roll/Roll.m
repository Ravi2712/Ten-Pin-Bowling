//
//  Roll.m
//  KataBowling-Challenge
//
//  Created by Ravi Patel on 4/2/17.
//  Copyright © 2017 Jay Patel. All rights reserved.
//

#import "Roll.h"
#import "GameRules.h"

@interface Roll()

@property (strong,nonatomic) GameRules *gameRulesObject ;

@end

@implementation Roll

-(id)initWithRoll:(NSString *)str
{
    self = [super init] ;
    
    if(self) {
        _rollValue = str ;
    }
    
    return self ;
}

-(void)handleRollAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HandleRollNotification" object:self userInfo:@{@"roll":self}];
}


@end

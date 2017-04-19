//
//  Frame.m
//  KataBowling-Challenge
//
//  Created by Ravi Patel on 4/2/17.
//  Copyright © 2017 Jay Patel. All rights reserved.
//

#import "Frame.h"

@interface Frame()

@end

@implementation Frame

@synthesize rollsArray = _rollsArray  ;

-(id)initWithFrameNumber:(NSInteger)number
{    
    self = [super init] ;
    
    if(self) {
        
        _rollsArray = [[NSMutableArray alloc] init] ;
        
        _frameNumber = number ;
        _frameScore = 0 ;
    }
    
    return self ;
    
}

@end

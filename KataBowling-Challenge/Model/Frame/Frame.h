//
//  Frame.h
//  KataBowling-Challenge
//
//  Created by Ravi Patel on 4/2/17.
//  Copyright © 2017 Jay Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Roll.h"

@interface Frame : NSObject

@property (assign) NSInteger frameNumber ;
@property (assign) NSInteger frameScore ;

@property (strong,nonatomic) NSMutableArray<Roll *> *rollsArray ;

-(id)initWithFrameNumber:(NSInteger)number ;

@end

//
//  GameRules.m
//  KataBowling-Challenge
//
//  Created by Ravi Patel on 4/3/17.
//  Copyright © 2017 Jay Patel. All rights reserved.
//

#import "GameRules.h"

/*
 
 GAME NAME : Ten-pin_bowling
 GAME RULES : https://en.wikipedia.org/wiki/Ten-pin_bowling
 
*/


#define MAX_ROLLS_PER_FRAME 2
#define MAX_ROLLS_IN_LAST_FRAME 3

#define ROLLS_OFFER_ON_STRIKE_EVENT 2
#define ROLLS_OFFER_ON_SPARE_EVENT 1

#define LAST_FRAME 10

static NSString * const strikeEvent = @"STRIKE" ;
static NSString * const spareEvent = @"SPARE" ;
static NSString * const missEvent = @"MISS" ;
static NSString * const numberEvent = @"NUMBER" ;

static NSDictionary *gameEventsShorthand ;



/*
 
 
 // Implement Queue to keep sequence of frames
 
 
*/


@interface KBQueue : NSObject
{
    NSMutableArray *array ;
}

// Removes and returns the element at the front of the queue
-(Frame *)dequeue;

// Add the element to the back of the queue
-(void)enqueue:(Frame *)element;

// Returns the element at the front of the queue
-(Frame *)peek;

// Returns YES if the queue is empty
-(BOOL)isEmpty;

// Returns the size of the queue
-(NSInteger)size;


@end


@implementation KBQueue

-(id)init
{
    if(self = [super init]) {
        array = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(Frame *)dequeue
{
    if ([array count] > 0) {
        Frame *object = [self peek];
        [array removeObjectAtIndex:0];
        return object;
    }
    
    return nil;
}

-(void)enqueue:(Frame *)element
{
    [array addObject:element];
}


-(Frame *)peek
{
    if ([array count] > 0)
        return [array objectAtIndex:0];
    
    return nil;
}

-(NSInteger)size
{
    return [array count];
}

-(BOOL)isEmpty
{
    return [array count] == 0;
}


@end




/*
 
 
 GAME RULES Class Implementation
 
 
*/


@interface GameRules()

@property (strong,nonatomic) Roll *currentRoll ;
@property (strong,nonatomic) Frame *currentFrame ;

//@property (strong,nonatomic) NSMutableArray<Frame *> *incompleteFramesArray ;
@property (strong,nonatomic) KBQueue *queueOfIncompleteFrames ;

@property (strong,nonatomic) Frame *incompleteFrame ;

@property (assign) NSInteger lastFrameRollCount ;
@property (assign) NSInteger additionalRollsCount ;

@property (assign) NSInteger totalPlayedFrames ;
@property (assign) NSInteger maxRollInLastFrame ;

@end


@implementation GameRules


-(id)init
{
    self = [super init] ;
    
    if(self) {
        
        //
        gameEventsShorthand = @{
                                @"X": strikeEvent,
                                @"/" : spareEvent,
                                @"-" : missEvent
                                };

        //
        _additionalRollsCount = 0 ;
        _totalPlayedFrames = 0 ;
        
        //
        _currentFrame = [[Frame alloc] initWithFrameNumber:_totalPlayedFrames + 1] ;
        
        //
        _queueOfIncompleteFrames = [[KBQueue alloc] init] ;
        [_queueOfIncompleteFrames enqueue:_currentFrame] ;
        _incompleteFrame = [_queueOfIncompleteFrames peek] ;
        
        //
        [self addObserverToRoll] ;
        
        //
        _maxRollInLastFrame = MAX_ROLLS_PER_FRAME ;
    }
    
    return self ;
}


#pragma mark - Add observer to roll

-(void)addObserverToRoll
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HandleRollNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRollNotification:) name:@"HandleRollNotification" object:nil];
}


/*
 
 Handle Roll Notification :-
 
 --> Add current roll to frame
 --> Check if last roll had special event(Strike or Spare), if YES --> add current roll score to incomplete frame score
 --> Handle Current Roll
 
*/

-(void)handleRollNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"HandleRollNotification"]) {
        
        _currentRoll = [[notification userInfo] valueForKey:@"roll"] ;
        
        //
        [_currentFrame.rollsArray addObject:_currentRoll] ;
        
        //
        if(_additionalRollsCount > 0) {
            [self additionalScoresFromSpecialEvents:_currentRoll] ;
        }
        
        //
        NSString *rollEventFromInput = [self eventFromRoll:_currentRoll] ;
     
        if ([rollEventFromInput isEqualToString:strikeEvent]) {
            
            [self strikeEvent:_currentRoll] ;
            
        } else if ([rollEventFromInput isEqualToString:spareEvent]) {
            
            [self spareEvent:_currentRoll] ;
            
        } else {
    
            [self simpleEvent:_currentRoll] ;
        }
    }
}

#pragma mark - Game rules implementation

-(void)changeFrame
{
    if(self.delegate) {
        [self.delegate createNewFrameToScoreBoard:_currentFrame] ;
    }
    
    _totalPlayedFrames += 1 ;
    _currentFrame = [[Frame alloc] initWithFrameNumber:_totalPlayedFrames + 1] ;
    
    if(_currentFrame.frameNumber != LAST_FRAME) {
        [_queueOfIncompleteFrames enqueue:_currentFrame] ;
        _incompleteFrame = [_queueOfIncompleteFrames peek] ;
    }
}

-(void)updateScore:(NSInteger)score
{
    if(self.delegate) {
        [self.delegate updateScoreBoard:score] ;
    }
}



#pragma mark - GAME_EVENT : Simple

/*
 
 SIMPLE EVENT :-
 
 --> Add score to current frame
 --> Max rolls per frame is TWO
 --> Change frame on max rolls

*/


-(void)simpleEvent:(Roll *)roll
{
    //
    _currentFrame.frameScore += [self scoreFromRoll:roll] ;
    

    //
    if(_currentFrame.frameNumber == LAST_FRAME) {
        [self lastFrameEvent:_currentRoll event:numberEvent] ;
    }
    
    //
    if(_currentFrame.frameNumber != LAST_FRAME && _currentFrame.rollsArray.count >= MAX_ROLLS_PER_FRAME) {
        [self changeFrame] ;
        [self additionalScoresFromSpecialEvents:roll] ;
    }
}



#pragma mark - GAME_EVENT : Spare

/*
 
 SPARE EVENT :-
 
 --> Default score is 10,
 --> Spare event offers to add next roll score to current frame
 --> Change frame on spare event
 
*/


-(void)spareEvent:(Roll *)roll
{
    //
    _currentFrame.frameScore = [self scoreFromRoll:roll] ;
    
    //
    if(_currentFrame.frameNumber == LAST_FRAME) {
        [self lastFrameEvent:_currentRoll event:spareEvent] ;
    }
    
    //
    if(_currentFrame.frameNumber != LAST_FRAME) {
        _additionalRollsCount = ROLLS_OFFER_ON_SPARE_EVENT ;
        [self changeFrame] ;
    }
}


#pragma mark - GAME_EVENT : Strike

/*
 
 --> STRIKE EVENT : -
        
    --> Default score is 10
    --> Strike event offers to add next 2 rolls score to current frame
    --> Change frame on strike event
 
*/


-(void)strikeEvent:(Roll *)roll
{
    //
    if(_currentFrame.frameNumber != LAST_FRAME && _additionalRollsCount == 0) {
        _additionalRollsCount = ROLLS_OFFER_ON_STRIKE_EVENT ;
    }
  
    //
    if(_currentFrame.frameNumber == LAST_FRAME) {
        _currentFrame.frameScore += [self scoreFromRoll:roll] ;
        [self lastFrameEvent:_currentRoll event:strikeEvent] ;
    }
    
    //
    if(_currentFrame.frameNumber != LAST_FRAME) {
        _currentFrame.frameScore = [self scoreFromRoll:roll] ;
        [self changeFrame] ;
    }
}


#pragma mark - GAME_EVENT : Lastframe

/*
 
 --> LAST FRAME EVENT : -
 
 --> If spare or strike in last frame, it offers 3 rolls for last frame
 --> Display final score

*/

-(void)lastFrameEvent:(Roll *)roll event:(NSString *)event
{
    //
    _lastFrameRollCount += 1 ;
    
    //
    switch (_lastFrameRollCount) {
        
        case 1:
            
            if([event isEqualToString:strikeEvent]) {
                _maxRollInLastFrame = MAX_ROLLS_IN_LAST_FRAME ;
            }
            
            break;
        
        case 2:
            
            if([event isEqualToString:spareEvent] || [event isEqualToString:strikeEvent]) {
                _maxRollInLastFrame = MAX_ROLLS_IN_LAST_FRAME ;
            }
            
            break;
            
        default:
            break;
    }
    
    if(_lastFrameRollCount == _maxRollInLastFrame) {
        if(self.delegate) {
            [self.delegate createNewFrameToScoreBoard:_currentFrame] ;
        }
    
        [self updateScore:_currentFrame.frameScore] ;
    }
}


#pragma mark - Special event handler

/*
 
 --> If special event happens, add additional score to special event frame
 --> After completion of special event, update score for incomplete frame
 
*/

-(void)additionalScoresFromSpecialEvents:(Roll *)roll
{
    
    if (_additionalRollsCount > 0) {
        
        NSInteger rollScore = [self scoreFromRoll:roll] ;
        NSString *rollEventFromInput = [self eventFromRoll:roll] ;
        
        //
        if([rollEventFromInput isEqualToString:spareEvent]) {
            
            _incompleteFrame.frameScore += 20 - (_incompleteFrame.frameScore)  ;
        
        } else if([rollEventFromInput isEqualToString:strikeEvent]) {
            
            _incompleteFrame.frameScore += 10 ;
            
        } else {
            
            _incompleteFrame.frameScore += rollScore ;
        }
        
        //
        _additionalRollsCount -= 1 ;
    }
    
    
    
    if (_additionalRollsCount == 0) {
          
        /*
         
        --> After special event completion update score
        --> Remove incomplete frame from Queue
         
        */
        
        [self updateScore:_incompleteFrame.frameScore] ;
        
        if(_queueOfIncompleteFrames.size > 0) {
            [_queueOfIncompleteFrames dequeue] ;
        }
        
        
        
        /*
         
        --> If any frame to handle from Queue
         
         
        */
        if(_queueOfIncompleteFrames.size > 0) {
            
            //
            _incompleteFrame = [_queueOfIncompleteFrames peek] ;
            
            if(_incompleteFrame.rollsArray.count > 0) {
                
                Roll *firstRollOfFrame = [_incompleteFrame.rollsArray objectAtIndex:0] ;
                
                NSString *rollEventFromInput = [self eventFromRoll:firstRollOfFrame] ;
                
                if([rollEventFromInput isEqualToString:strikeEvent]) {
                    
                    NSInteger rollScore = [self scoreFromRoll:roll] ;
                    _incompleteFrame.frameScore += rollScore ;
                    
                    if(_incompleteFrame != _currentFrame)
                        _additionalRollsCount = 1 ;
                }
            }
        }
    }
    
}



#pragma mark - Roll Helper

-(NSInteger)scoreFromRoll:(Roll *)roll
{
    NSInteger rollScore ;
    
    NSString *rollEventFromInput = [gameEventsShorthand valueForKey:roll.rollValue] ;
    
    if([rollEventFromInput isEqualToString:strikeEvent]) {
        rollScore = 10 ;
    } else if([rollEventFromInput isEqualToString:spareEvent]) {
        rollScore = 10 ;
    } else if([rollEventFromInput isEqualToString:missEvent]) {
        rollScore = 0 ;
    } else {
        rollScore = [roll.rollValue intValue] ;
    }
    
    return rollScore ;
}


-(NSString *)eventFromRoll:(Roll *)roll
{
    NSString *rollEvent = [gameEventsShorthand valueForKey:roll.rollValue] ;
    
    if([rollEvent isEqualToString:strikeEvent]) {
        
        return strikeEvent ;
    
    } else if([rollEvent isEqualToString:spareEvent]) {
        
        return spareEvent ;
        
    } else {
        
        return numberEvent ;
        
    }
}

@end


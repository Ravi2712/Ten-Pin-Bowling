# Kata Bowling Score Generator

Ten-pin bowling is a game in which a player (called a "bowler") rolls a bowling ball down a wood-structure or synthetic (polyurethane) lane and towards ten pins positioned at the end of the lane.

This repositiory gives the Final Score of Valid rolls for Player. Game rules are implemented as per traditional calculation of this game. 
For More info : https://en.wikipedia.org/wiki/Ten-pin_bowling

## Run configuration

This program is written in Objective-C. You will be needed Xcode or Objective-C Compiler to run the program.
Run Xcode Project.

## Usage

Program is designed for multiple players, as well. 
Here, is the developed Model classes.

```
 ├───Player
 │
 ├───GameRules
 │
 ├───ScoreBoard
 │
 ├───Frame
 │
 ├───Roll
```

#### Player

Create Player Object, whith Scoreboard object. 

```
ScoreBoard *board = [[ScoreBoard alloc] init] ;
Player *player = [[Player alloc] initWithPlayerName:@"Player_name" scoreBoard:board] ;
```

Player performs roll action.

```
-(void)rollTheBall:(NSString *)str ;
```

#### ScoreBoard 

Player will be able to see ScoreBoard.

```
-(void)printScoreBoard ;
```

## Implementation of GameRules

GameRules class is being made for implementation of Game rules. Implementation of Gamerules Protocol provides the ability of getting score.<br/>
So, Scoreboard implements the Game Rules Protocol. 

```
@protocol GameRules_Delegates <NSObject>

@required
-(void)createNewFrameToScoreBoard:(Frame *)frame ;
-(void)updateScoreBoard:(NSInteger)score ;
@end
```

Program is implemented with Observer and Delegation Design Pattern.<br/>
--> Player rolls the ball first, each roll is observable and so, With Game rules observer program will be able to generate score.<br/>
--> When score is available, with delegation pattern score board will be updated.<br/>

At lower level, program also uses Queue to keep time complexity O(n). 


## Program Time Complexity

Program runs with O(n) time complexity.


## Result of Sample Test Case

Test case : 7/21216/12124/321321 <br/>
Score : 60

## Credits

**JAY PATEL**

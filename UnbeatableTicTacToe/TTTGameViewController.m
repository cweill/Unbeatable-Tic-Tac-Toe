//
//  TTTGameViewController.m
//  UnbeatableTicTacToe
//
//  Created by Charlie Weill on 12/8/14.
//  Copyright (c) 2014 Charlie Weill. All rights reserved.
//

#import "TTTGameViewController.h"
#import "TTTGameView.h"
#import "TTTGameState.h"
#import "TTTPlayerAI.h"

@interface TTTGameViewController () <TTTGameViewDelegate>

@property (strong, nonatomic) TTTGameState *gameTree; // The game tree - each node is a game state
@property (strong, nonatomic) TTTGameState *currentState; // Current node in game state tree
@property (strong, nonatomic) TTTGameView *gameView;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) UIButton *dismissGameButton;
@property (strong, nonatomic) UILabel *gameStatusLabel;

@end

@implementation TTTGameViewController

- (instancetype)initWithGameState:(TTTGameState *)state {
  self = [self init];
  if (self) {
    _gameTree = state;
    _currentState = state;
  }
  return self;
}

- (void)loadView{
  self.view = [UIView new];
  self.view.backgroundColor = [UIColor whiteColor];
  
  _gameView = [TTTGameView new];
  _gameView.delegate = self;
  
  _gameStatusLabel = [UILabel new];
  _gameStatusLabel.textAlignment = NSTextAlignmentCenter;
  
  _resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [_resetButton setTitle:@"Reset" forState:UIControlStateNormal];
  [_resetButton addTarget:self
                   action:@selector(resetGame)
         forControlEvents:UIControlEventTouchUpInside];
  
  _dismissGameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [_dismissGameButton setTitle:@"New Game" forState:UIControlStateNormal];
  [_dismissGameButton addTarget:self
                        action:@selector(dismissGame)
              forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:_gameView];
  [self.view addSubview:_gameStatusLabel];
  [self.view addSubview:_dismissGameButton];
  [self.view addSubview:_resetButton];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self resetGame];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  
  CGFloat gameDimension = self.view.frame.size.width - 30;
  
  _gameView.frame = CGRectMake(15, 64, gameDimension, gameDimension);
  
  _gameStatusLabel.frame = CGRectMake(0,
                                      CGRectGetMaxY(_gameView.frame) + 15,
                                      self.view.frame.size.width,
                                      20);
  
  _dismissGameButton.frame = CGRectMake(0,
                                        self.view.frame.size.height - 100,
                                        self.view.frame.size.width / 2,
                                        100);
  
  _resetButton.frame = CGRectMake(self.view.frame.size.width / 2,
                                  self.view.frame.size.height - 100,
                                  self.view.frame.size.width / 2,
                                  100);
}

- (void)gameView:(TTTGameView *)gameView didTapTile:(NSUInteger)tile {
  if ([_currentState.currentPlayer isKindOfClass:[TTTPlayerAI class]]) return;
  TTTGameState *nextState = [_currentState makeMove:tile];
  if (nextState) {
    [self displayNextState:nextState];
    if ([nextState.currentPlayer isKindOfClass:[TTTPlayerAI class]]) {;
      [self playAI];
    }
  }
}

- (void)playAI {
  if (_currentState.status == TTTGameStatusInPlay &&
      [_currentState.currentPlayer isKindOfClass:[TTTPlayerAI class]]) {
    TTTPlayerAI *playerAI = (TTTPlayerAI *)_currentState.currentPlayer;
    
    // Run Min Max in background since otherwise it will hog the UI thread
    __weak TTTGameViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      TTTGameState *bestMove = [playerAI bestMoveForGameState:weakSelf.currentState];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf displayNextState:bestMove];
      });
    });
  }
}

- (void)displayNextState:(TTTGameState *)nextState {
  if (nextState) {
    _currentState = nextState;
    [_gameView drawGameState:nextState];
    
    [self displayGameStatusText];
  }
}

- (void)displayGameStatusText {
  switch (_currentState.status) {
    case TTTGameStatusDraw:
      _gameStatusLabel.text = @"Draw!";
      break;
    case TTTGameStatusPlayerXWon:
      _gameStatusLabel.text = @"Player X Won!";
      break;
    case TTTGameStatusPlayerOWon:
      _gameStatusLabel.text = @"Player O Won!";
      break;
    default:
      _gameStatusLabel.text = [NSString stringWithFormat:@"Player %@'s Move", _currentState.currentPlayer.letter];
      break;
  }
}

- (void)resetGame {
  [_gameView reset]; // Reset view
  _currentState = _gameTree; // Reset game state
  [self displayGameStatusText];
  
  [self playAI];
}

- (void)dismissGame {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  TwoPlayerSetCardGameViewController.m
//  Matchismo
//
//  Created by Martin Mandl on 02.12.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "TwoPlayerSetCardGameViewController.h"

@interface TwoPlayerSetCardGameViewController ()

@property (strong, nonatomic) NSMutableArray *playerScores; // of NSNumber
@property (nonatomic) NSUInteger currentPlayer;

@end

@implementation TwoPlayerSetCardGameViewController

- (NSMutableArray *)playerScores
{
    if (!_playerScores) {
        _playerScores = [NSMutableArray arrayWithArray:@[@0, @0]];
    }
    return _playerScores;
}

- (void)calculateMultiPlayerScore
{
    NSUInteger otherPlayer = (self.currentPlayer + 1) % 2;
    NSInteger newScore = self.game.score - [self.playerScores[otherPlayer] integerValue];
    if ((newScore + self.gameSettings.flipCost < [self.playerScores[self.currentPlayer] integerValue])
        || self.scoreAdjustment) {
        self.playerScores[self.currentPlayer] = @(newScore);
        self.currentPlayer = otherPlayer;
        self.scoreAdjustment = 0;
    } else {
        self.playerScores[self.currentPlayer] = @(newScore);
    }
}

- (void)updateUI
{
    [super updateUI];
    [self calculateMultiPlayerScore];
    
    NSString *text = [NSString stringWithFormat:@"P1: %@  P2: %@",
                      self.playerScores[0], self.playerScores[1]];
    NSMutableAttributedString *label = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:[NSString stringWithFormat:@"P%ld: %@",
                                         (long)(self.currentPlayer + 1),
                                         self.playerScores[self.currentPlayer]]];
    if (range.location != NSNotFound) {
        [label addAttributes:@{ NSStrokeWidthAttributeName : @-3,NSForegroundColorAttributeName : [UIColor blueColor] }
                       range:range];
    }    
    self.scoreLabel.attributedText = label;
}

- (void)touchDealButton:(UIButton *)sender
{
    self.playerScores = nil;
    self.currentPlayer = 0;
    [super touchDealButton:sender];
}

@end

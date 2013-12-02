//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Martin Mandl on 02.11.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//
// Abstract class. Must implement methods as described below.

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"
#import "GameSettings.h"

@interface CardGameViewController : UIViewController

// protected
// for subclasses
- (Deck *)createDeck; // abstract
- (UIView *)createViewForCard:(Card *)card;
- (void)updateView:(UIView *)view forCard:(Card *)card;

- (void)updateUI;

@property (strong, nonatomic) NSString *gameType;
@property (nonatomic) NSUInteger numberOfStartingCards;
@property (nonatomic) CGSize maxCardSize;
@property (nonatomic) BOOL removeMatchingCards;

@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) GameSettings *gameSettings;
@property (nonatomic) NSInteger scoreAdjustment;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

- (IBAction)touchDealButton:(UIButton *)sender;

@end

//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Martin Mandl on 02.11.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;
@property (strong, nonatomic) NSMutableArray *flipHistory;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

@end

@implementation CardGameViewController

- (NSMutableArray *)flipHistory
{
    if (!_flipHistory) {
        _flipHistory = [NSMutableArray array];
    }
    return _flipHistory;
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
        [self changeModeSelector:self.modeSelector];
    }
    return _game;
}

- (Deck *)createDeck // abstract
{
    return nil;
}
    
- (IBAction)touchDealButton:(UIButton *)sender {
    self.modeSelector.enabled = YES;
    self.game = nil;
    self.flipHistory = nil;
    [self updateUI];
}

- (IBAction)changeModeSelector:(UISegmentedControl *)sender {
    self.game.maxMatchingCards = [[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] integerValue];
}

- (void)setSliderRange
{
    int maxValue = [self.flipHistory count] - 1;
    self.historySlider.maximumValue = maxValue;
    [self.historySlider setValue:maxValue animated:YES];
}

- (IBAction)changeSlider:(UISlider *)sender {
    int sliderValue;
    sliderValue = lroundf(self.historySlider.value);
    [self.historySlider setValue:sliderValue animated:NO];
    
    if ([self.flipHistory count]) {
        self.flipDescription.alpha =
        (sliderValue + 1 < [self.flipHistory count]) ? 0.6 : 1.0;
        self.flipDescription.text =
        [self.flipHistory objectAtIndex:sliderValue];
    }
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    self.modeSelector.enabled = NO;
    int cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setAttributedTitle:[self titleForCard:card]
                              forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.matched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    if (self.game) {
        NSString *description = @"";
        
        if ([self.game.lastChosenCards count]) {
            NSMutableArray *cardContents = [NSMutableArray array];
            for (Card *card in self.game.lastChosenCards) {
                [cardContents addObject:card.contents];
            }
            description = [cardContents componentsJoinedByString:@" "];
        }
        
        if (self.game.lastScore > 0) {
            description = [NSString stringWithFormat:@"Matched %@ for %d points.", description, self.game.lastScore];
        } else if (self.game.lastScore < 0) {

            description = [NSString stringWithFormat:@"%@ don’t match! %d point penalty!", description, -self.game.lastScore];
        }
        
        self.flipDescription.text = description;
        self.flipDescription.alpha = 1;
        
        if (![description isEqualToString:@""] && ![[self.flipHistory lastObject] isEqualToString:description]) {
            [self.flipHistory addObject:description];
            [self setSliderRange];
        }
    }
}

- (NSAttributedString *)titleForCard:(Card *)card
{
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:card.chosen ? card.contents : @""];
    return title;
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.chosen ? @"cardfront" : @"cardback"];
}

@end

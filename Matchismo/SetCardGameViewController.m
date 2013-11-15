//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Martin Mandl on 13.11.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "CardMatchingGame.h"
#import "HistoryViewController.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSAttributedString *)titleForCard:(Card *)card
{
    NSString *symbol = @"?";
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        
        if ([setCard.symbol isEqualToString:@"oval"]) symbol = @"●";
        if ([setCard.symbol isEqualToString:@"squiggle"]) symbol = @"▲";
        if ([setCard.symbol isEqualToString:@"diamond"]) symbol = @"■";
        
        symbol = [symbol stringByPaddingToLength:setCard.number
                                      withString:symbol
                                 startingAtIndex:0];

        if ([setCard.color isEqualToString:@"red"])
            [attributes setObject:[UIColor redColor]
                           forKey:NSForegroundColorAttributeName];
        if ([setCard.color isEqualToString:@"green"])
            [attributes setObject:[UIColor greenColor]
                           forKey:NSForegroundColorAttributeName];
        if ([setCard.color isEqualToString:@"purple"])
            [attributes setObject:[UIColor purpleColor]
                           forKey:NSForegroundColorAttributeName];
        
        if ([setCard.shading isEqualToString:@"solid"])
            [attributes setObject:@-5
                           forKey:NSStrokeWidthAttributeName];
        if ([setCard.shading isEqualToString:@"striped"])
            [attributes addEntriesFromDictionary:@{
                                                   NSStrokeWidthAttributeName : @-5,
                                                   NSStrokeColorAttributeName : attributes[NSForegroundColorAttributeName],
                                                   NSForegroundColorAttributeName : [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.1]
                                                   }];
        if ([setCard.shading isEqualToString:@"open"])
            [attributes setObject:@5 forKey:NSStrokeWidthAttributeName];
    }

    return [[NSMutableAttributedString alloc] initWithString:symbol
                                                  attributes:attributes];
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.chosen ? @"setCardSelected" : @"setCard"];
}

- (NSAttributedString *)replaceCardDescriptionsInText:(NSAttributedString *)text
{
    NSMutableAttributedString *newText = [text mutableCopy];
    
    NSArray *setCards = [SetCard cardsFromText:text.string];
    
    if (setCards) {
        for (SetCard *setCard in setCards) {
            NSRange range = [newText.string rangeOfString:setCard.contents];
            if (range.location != NSNotFound) {
                [newText replaceCharactersInRange:range
                             withAttributedString:[self titleForCard:setCard]];
            }
        }
    }
    return newText;
}

- (void)updateUI
{
    [super updateUI];
    
    self.flipDescription.attributedText = [self replaceCardDescriptionsInText:self.flipDescription.attributedText];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show History"]) {
        if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
            NSMutableArray *attributedHistory = [NSMutableArray array];
            for (NSString *flip in self.flipHistory) {
                NSAttributedString *attributedFlip = [[NSAttributedString alloc] initWithString:flip];
                [attributedHistory addObject:[self replaceCardDescriptionsInText:attributedFlip]];
            }
            [segue.destinationViewController setHistory:attributedHistory];
        }
    }
}


@end

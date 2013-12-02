//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Martin Mandl on 06.11.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, strong) NSArray *lastChosenCards;
@property (nonatomic, readwrite) NSInteger lastScore;
@property (strong, nonatomic) Deck *deck;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}
    
- (NSUInteger)maxMatchingCards
{
    Card *card = [self.cards firstObject];
    if (_maxMatchingCards < card.numberOfMatchingCards) {
        _maxMatchingCards = card.numberOfMatchingCards;
    }
    return _maxMatchingCards;
}

- (NSUInteger)numberOfDealtCards {
    return [self.cards count];
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        _deck = deck;
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
            _matchBonus = MATCH_BONUS;
            _mismatchPenalty = MISMATCH_PENALTY;
            _flipCost = COST_TO_CHOOSE;
        }
    }
    
    return self;
}

//#define MISMATCH_PENALTY 2
static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            NSMutableArray *otherCards = [NSMutableArray array];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [otherCards addObject:otherCard];
                }
            }
            self.lastScore = 0;
            self.lastChosenCards = [otherCards arrayByAddingObject:card];
            if ([otherCards count] + 1 == self.maxMatchingCards) {
                int matchScore = [card match:otherCards];
                if (matchScore) {
                    self.lastScore = matchScore * self.matchBonus;
                    card.matched = YES;
                    for (Card *otherCard in otherCards) {
                        otherCard.matched = YES;
                    }
                } else {
                    self.lastScore = - self.mismatchPenalty;
                    for (Card *otherCard in otherCards) {
                        otherCard.chosen = NO;
                    }
                }
            }
            self.score += self.lastScore - self.flipCost;
            card.chosen = YES;
        }
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void)drawNewCard
{
    Card *card = [self.deck drawRandomCard];
    if (card) {
        [self.cards addObject:card];
    }
}

- (BOOL)deckIsEmpty
{
    Card *card = [self.deck drawRandomCard];
    if (card) {
        [self.deck addCard:card];
        return NO;
    }
    return YES;
}

- (NSArray *)nextCombinationAfter:(NSArray *)combination withNumberOfCards:(NSUInteger)numberOfCards
{
    NSUInteger n = [self.cards count];
    NSUInteger k = numberOfCards;
    NSUInteger i = k - 1;
    NSMutableArray *next = [combination mutableCopy];
    next[i] = @([next[i] intValue] + 1);
    while ((i > 0) && ([next[i] intValue] > n - k + i)) {
        i--;
        next[i] = @([next[i] intValue] + 1);
    }
    if ([next[0] intValue] > n - k) return nil;
    for (i = i + 1; i < k; ++i) {
        next[i] = @([next[i - 1] intValue] + 1);
    }
    return next;
}

- (NSArray *)cardsFromCombination:(NSArray *)combination startinWithIndex:(NSUInteger)start
{
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    for (NSUInteger i = start; i < [combination count]; i++) {
        [cards addObject:self.cards[[combination[i] intValue]]];
    }
    return cards;
}

- (NSArray *)cardsFromCombination:(NSArray *)combination
{
    return [self cardsFromCombination:combination startinWithIndex:0];
}

- (NSArray *)otherCardsFromCombination:(NSArray *)combination
{
    return [self cardsFromCombination:combination startinWithIndex:1];
}

- (BOOL)validCombination:(NSArray *)combination
{
    for (NSNumber *index in combination) {
        Card *card = self.cards[[index intValue]];
        if (card.matched) return NO;
    }
    return YES;
}

- (NSArray *)findCombination
{
    Card *card = [self.cards firstObject];
    NSMutableArray *combination = [NSMutableArray array];
    for (NSUInteger i = 0; i < card.numberOfMatchingCards; i++) {
        [combination addObject:@(i)];
    }
    
    NSArray *foundCombination;
    NSArray *nextCombination = combination;
    do {
        if (![self validCombination:nextCombination]) continue;
        if ([self.cards[[nextCombination[0] intValue]] match:[self otherCardsFromCombination:nextCombination]]) {
            foundCombination = [self cardsFromCombination:nextCombination];
            break;
        }
    } while ((nextCombination = [self nextCombinationAfter:nextCombination withNumberOfCards:card.numberOfMatchingCards]));
    
    return foundCombination;
}

@end

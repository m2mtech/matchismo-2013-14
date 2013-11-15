//
//  ScoresViewController.m
//  Matchismo
//
//  Created by Martin Mandl on 15.11.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "ScoresViewController.h"
#import "GameResult.h"

@interface ScoresViewController ()

@property (weak, nonatomic) IBOutlet UITextView *scoresTextView;
@property (strong, nonatomic) NSArray *scores; // of GameResults

@end

@implementation ScoresViewController

- (NSString *)stringFromResult:(GameResult *)result
{
    return [NSString stringWithFormat:@"%@: %d, (%@, %gs)\n",
            result.gameType,
            result.score,
            [NSDateFormatter localizedStringFromDate:result.end
                                           dateStyle:NSDateFormatterShortStyle
                                           timeStyle:NSDateFormatterShortStyle],
            round(result.duration)];
}

- (void)changeScore:(GameResult *)result toColor:(UIColor *)color
{
    NSRange range = [self.scoresTextView.text rangeOfString:[self stringFromResult:result]];
    [self.scoresTextView.textStorage addAttribute:NSForegroundColorAttributeName
                                            value:color
                                            range:range];
}

- (void)updateUI
{
    NSString *text = @"";
    for (GameResult *result in self.scores) {
        text = [text stringByAppendingString:[self stringFromResult:result]];
    }
    self.scoresTextView.text = text;
    
    NSArray *sortedScores = [self.scores sortedArrayUsingSelector:@selector(compareScore:)];
    [self changeScore:[sortedScores firstObject] toColor:[UIColor redColor]];
    [self changeScore:[sortedScores lastObject] toColor:[UIColor greenColor]];
    sortedScores = [self.scores sortedArrayUsingSelector:@selector(compareDuration:)];
    [self changeScore:[sortedScores firstObject] toColor:[UIColor purpleColor]];
    [self changeScore:[sortedScores lastObject] toColor:[UIColor blueColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scores = [GameResult allGameResults];
    [self updateUI];
}

@end

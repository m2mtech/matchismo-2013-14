//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Martin Mandl on 15.11.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@property (weak, nonatomic) IBOutlet UITextView *historyTextView;

@end

@implementation HistoryViewController

- (void)setHistory:(NSArray *)history
{
    _history = history;
    if (self.view.window) [self updateUI];
}

- (void)updateUI
{
    if ([[self.history firstObject] isKindOfClass:[NSAttributedString class]]) {
        NSMutableAttributedString *historyText = [[NSMutableAttributedString alloc] init];
        int i = 1;
        for (NSAttributedString *line in self.history) {
            [historyText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%2d: ", i++]]];
            [historyText appendAttributedString:line];
            [historyText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n" ]];
        }
        UIFont *font = [self.historyTextView.textStorage attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
        [historyText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, historyText.length)];
        self.historyTextView.attributedText = historyText;
    } else {
        NSString *historyText = @"";
        int i = 1;
        for (NSString *line in self.history) {
            historyText = [NSString stringWithFormat:@"%@%2d: %@\n\n", historyText, i++, line];
        }
        self.historyTextView.text = historyText;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

@end

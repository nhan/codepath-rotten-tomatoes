//
//  MovieDetailViewController.m
//  TopMovies
//
//  Created by Nhan Nguyen on 3/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"


@interface MovieDetailViewController ()
@property (nonatomic, strong) Movie* movie;
@property (weak, nonatomic) IBOutlet UIImageView *bigPosterView;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *castLabel;
@end

@implementation MovieDetailViewController

- (instancetype) initWithMovie:(Movie *)movie
{
    self = [super init];

    if (self) {
        self.movie = movie;
        self.title = movie.title;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.synopsisLabel.text = self.movie.synopsis;
    self.castLabel.text = [self.movie.cast componentsJoinedByString:@", "];
    [self.synopsisLabel sizeToFit];
    [self.castLabel sizeToFit];
    [self.bigPosterView setImageWithURL:self.movie.bigPosterURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

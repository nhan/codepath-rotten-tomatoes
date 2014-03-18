//
//  MoviesViewController.m
//  TopMovies
//
//  Created by Nhan Nguyen on 3/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "Movie.h"
#import "MovieDetailViewController.h"
#import "MMProgressHud.h"

@interface MoviesViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* movies;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (strong, nonatomic) UILabel* errorLabel;
@property (weak, nonatomic) UIImage* placeholderImage;
@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Movies";
        [self fetchMovies:self];
    }
    
    self.placeholderImage = [UIImage imageNamed:@"placeholder_big.gif"];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100;
    
    UINib *movieCellNib = [UINib nibWithNibName:@"MovieCellView" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:movieCellNib forCellReuseIdentifier:@"MovieCell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies:) forControlEvents:UIControlEventValueChanged];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.movies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    Movie* movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie.title;
    cell.synopsisLabel.text = movie.synopsis;
    cell.castLabel.text = [movie.cast componentsJoinedByString:@", "];
    [cell.posterThumbnail setImageWithURL:movie.smallPosterURL placeholderImage:self.placeholderImage];
    return cell;
}

// Tap on table Row
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    [self showMovieDetailsForRow:indexPath.row];
}

// Tap on arrow
- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath
{
    [self showMovieDetailsForRow:indexPath.row];
}

- (void) showMovieDetailsForRow:(int) row
{
    MovieDetailViewController* detailsVC = [[MovieDetailViewController alloc] initWithMovie:self.movies[row]];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)fetchMovies:(id) sender
{    
    // Only show loading spinner during initial load.  Refresh control has its own spinner.
    if (sender == self) {
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleNone];
        [MMProgressHUD showWithStatus:@"Loading"];
    }

    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        BOOL success = NO;
        
        if (connectionError == nil) {
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                id parsed = [self parseMovies:object[@"movies"]];
                if ([parsed isKindOfClass:[NSArray class]]) {
                    self.movies = parsed;
                    success = YES;
                }
            }
        }
        
        if (success) {
            [self hideError];
            [self.tableView reloadData];
        } else {
            [self showError];
        }
        
        [MMProgressHUD dismiss];
        [self.refreshControl endRefreshing];
    }];
}

// Converts NSArray of NSDictionary to NSArray of Movies
// TODO: how to try-catch-throw error if parse fails?
-(NSArray*) parseMovies:(NSArray*)movies
{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    for (NSDictionary* dict in movies) {
        Movie* movie = [[Movie alloc] initWithDictionary:dict];
        [ret addObject:movie];
    }
    return ret;
}

-(void) showError
{
    // lazyily create error network error view if necessary
    if (self.errorLabel == nil) {
        UILabel* errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        errorLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.8];
        errorLabel.text = @"Couldn't download movie list.";
        errorLabel.textAlignment = NSTextAlignmentCenter;
        errorLabel.textColor = [UIColor colorWithWhite:220.0 alpha:1.0];
        self.errorLabel = errorLabel;
        [self.tableView addSubview:self.errorLabel];
    }
    
    [self.tableView bringSubviewToFront:self.errorLabel];
}

-(void) hideError
{
    [self.tableView sendSubviewToBack:self.errorLabel];
}

@end

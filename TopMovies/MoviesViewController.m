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

@interface MoviesViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* movies;
@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Movies";
        [self reload];
    }
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [cell.posterThumbnail setImageWithURL:movie.smallPosterURL];
    return cell;
}

// Tap on table Row
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    [self showMovieDetailsForRow:indexPath.row];
}

// Tap on row accessory
- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath
{
    [self showMovieDetailsForRow:indexPath.row];
}

- (void) showMovieDetailsForRow:(int) row
{
    MovieDetailViewController* detailsVC = [[MovieDetailViewController alloc] initWithMovie:self.movies[row]];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)reload
{
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        if (connectionError != nil) {
            [self showError];
            return;
        }
        
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if ([object isKindOfClass:[NSDictionary class]]) {
            self.movies = [self parseMovies:object[@"movies"]];
        } else {
            [self showError];
            return;
        }
        
        [self.tableView reloadData];
    }];
}

// Converts NSArray of NSDictionary to NSArray of Movies
// TODO: how to throw error if parse fails?
-(NSArray*) parseMovies:(NSArray*)movies
{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    for (NSDictionary* dict in movies) {
        NSLog(@"%@", dict);
        Movie* movie = [[Movie alloc] initWithDictionary:dict];
        [ret addObject:movie];
    }
    return ret;
}

-(void) showError
{
    NSLog(@"Got error");
}

@end

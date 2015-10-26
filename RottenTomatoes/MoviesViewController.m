//
//  ViewController.m
//  RottenTomatoes
//
//  Created by Jim Challenger on 10/20/15.
//  Copyright © 2015 Jim Challenger. All rights reserved.
//

#import "MoviesViewController.h"
#import "MoviesTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailsViewController.h"
#import "M2DHudView.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIView *errorView;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.errorView.hidden = true;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.title = @"Movies";
    [self fetchMovies];
    
    // Set up refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) onRefresh {
    [self fetchMovies];
}

- (void)fetchMovies {
    // Loading
    M2DHudView *hud = [[M2DHudView alloc] initWithStyle:M2DHudViewStyleLoading title:nil];
    [hud show];
    
    NSString *urlString =
    @"https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json";
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    NSLog(@"Response: %@", responseDictionary);
                                                    self.movies = responseDictionary[@"movies"];
                                                    [self.refreshControl endRefreshing];
                                                    [self.tableView reloadData];
                                                    [hud dismiss];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                    self.errorView.hidden = false;
                                                    [hud dismiss];
                                                }
                                            }];
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoviesTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    cell.titleLabel.text = self.movies[indexPath.row][@"title"];
    cell.synopsisLabel.text = self.movies[indexPath.row][@"synopsis"];
    [cell.synopsisLabel sizeToFit];
    
    // Load and set image
    NSString *urlString = self.movies[indexPath.row][@"posters"][@"thumbnail"];
    NSRange range = [urlString rangeOfString:@".*cloudfront.net/"
                                     options:NSRegularExpressionSearch];
    NSString *newUrlString = [urlString stringByReplacingCharactersInRange:range
                                                                withString:@"https://content6.flixster.com/"];
    NSURL *url = [NSURL URLWithString:newUrlString];
    [cell.posterImageView setImageWithURL:url];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    MovieDetailsViewController *vc = [[MovieDetailsViewController alloc] init];
//    vc.movie = so that view knows about movie
    vc.movie = self.movies[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

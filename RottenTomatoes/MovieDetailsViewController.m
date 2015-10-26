//
//  MovieDetailsViewController.m
//  RottenTomatoes
//
//  Created by Jim Challenger on 10/20/15.
//  Copyright © 2015 Jim Challenger. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.synopsisLabel.text = self.movie[@"synopsis"];
    [self.synopsisLabel sizeToFit];
    

    self.scrollView.contentSize = CGSizeMake(self.detailsView.frame.size.width, self.detailsView.frame.size.height + self.detailsView.frame.origin.y + self.titleLabel.frame.size.height + self.synopsisLabel.frame.size.height);
    
    self.titleLabel.text = self.movie[@"title"];

    
    // Load and set image
    NSString *urlString = self.movie[@"posters"][@"thumbnail"];
    NSRange range = [urlString rangeOfString:@".*cloudfront.net/"
                                             options:NSRegularExpressionSearch];
    NSString *newUrlString = [urlString stringByReplacingCharactersInRange:range
                                                                withString:@"https://content6.flixster.com/"];
    NSURL *url = [NSURL URLWithString:newUrlString];
//    NSData *imageData = [NSData dataWithContentsOfURL:url];
//    self.backgroundImage.image = [UIImage imageWithData:imageData];
    [self.backgroundImage setImageWithURL:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

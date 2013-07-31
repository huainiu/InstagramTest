//
//  ViewController.m
//  InstagramTest
//
//  Created by Бондик Киричков on 25.07.13.
//  Copyright (c) 2013 Kirichkov's. All rights reserved.
//

#import "ViewController.h"
#import "InstagramLoginView.h"
#import "InstagramUserFeed.h"


@interface ViewController ()

@property (strong) InstagramUserFeed * feed;

-(void)showLoginScreen;
@end

@implementation ViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        //UITableView * tempView = [[UITableView alloc] init];
        //self.tableView = tempView;
        
        CGRect footerRect = CGRectMake(0, 0, 320, 40);
        UILabel * footerCell = [[UILabel alloc] initWithFrame:footerRect];
        footerCell.text = @"Loading";
        self.tableView.tableFooterView = footerCell;
        
        self.feed = [[InstagramUserFeed alloc] init];
        self.tableView.dataSource = _feed;
        _feed.display = self;
        //tempView.delegate = _feed;
    }
    return self;
}

-(void)refresh {
    
    [_feed refreshFeed];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    if (self.feed.accessToken == nil) {
        [self showLoginScreen];
    }
}

-(void)showLoginScreen {
    
    //prepaire views
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    InstagramLoginView * loginView = [[InstagramLoginView alloc] init];
    UIViewController * loginController = [[UIViewController alloc] init];
    loginController.view = loginView;
    loginView.delegate = self;
    loginController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:loginController animated:YES completion:nil];
    
    [loginView runRequests];

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSRange tokenLocation = [request.URL.absoluteString rangeOfString:@"#access_token"];
    if (tokenLocation.location!=NSNotFound) {
        self.feed.accessToken = [request.URL.absoluteString substringFromIndex:(tokenLocation.location+1)];
        [webView stopLoading];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [self.feed refreshFeed];
        [self.tableView reloadData];
        return FALSE;
    }
    return YES;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    float targetLowerPoint = targetContentOffset->y + scrollView.frame.size.height;
    
    // if there is less than one screen before end get more content from Instagram
    if (targetLowerPoint + scrollView.frame.size.height > scrollView.contentSize.height) {
        [_feed getOlderMedia];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

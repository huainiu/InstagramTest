//
//  ViewController.m
//  InstagramTest
//
//  Created by Бондик Киричков on 25.07.13.
//  Copyright (c) 2013 Kirichkov's. All rights reserved.
//

#import "ViewController.h"
#import "InstagramLoginView.h"

@interface ViewController ()

@property (strong) NSString * accessTokenString;

-(void)showLoginScreen;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    if (self.accessTokenString == nil) {
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
        self.accessTokenString = [request.URL.absoluteString substringFromIndex:tokenLocation.location];
        [webView stopLoading];
        [self dismissViewControllerAnimated:YES completion:nil];
        return FALSE;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

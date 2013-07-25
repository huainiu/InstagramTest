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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
    InstagramLoginView * loginView = [[InstagramLoginView alloc] init];
    UIViewController * loginController = [[UIViewController alloc] init];
    loginController.view = loginView;
    
    loginView.delegate = self;
    NSURLRequest * loginPageRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://instagram.com/oauth/authorize/?client_id=906dd5e1f5574465a28f6d3f905f9981&redirect_uri=instatestapp://server.com/&response_type=token"]];
    [loginView loadRequest:loginPageRequest];
    loginController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    
    
    [self presentViewController:loginController animated:YES completion:nil];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"%@",request.URL.absoluteString);
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

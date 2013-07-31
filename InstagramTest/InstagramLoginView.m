//
//  InstagramLoginView.m
//  InstagramTest
//
//  Created by Бондик Киричков on 25.07.13.
//  Copyright (c) 2013 Kirichkov's. All rights reserved.
//

#import "InstagramLoginView.h"

@implementation InstagramLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)runRequests {
    
    __weak id weakSelf = self;
    //logout first
    NSURLRequest * logoutRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://instagram.com/accounts/logout/"]];
    AFHTTPRequestOperation * logoutOperation = [[AFHTTPRequestOperation alloc] initWithRequest:logoutRequest];
    [logoutOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * operation, id response) {
        
        //login if logout was successful
        NSURLRequest * loginPageRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://instagram.com/oauth/authorize/?client_id=906dd5e1f5574465a28f6d3f905f9981&redirect_uri=instatestapp://server.com/&response_type=token"]];
        [weakSelf loadRequest:loginPageRequest];
    }
                                           failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                                               
                                               NSLog(@"INSTA is unreachable");
                                               
                                           }];
    
    [logoutOperation start];
}


@end

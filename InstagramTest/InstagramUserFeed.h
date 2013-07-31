//
//  InstagramUserFeed.h
//  InstagramTest
//
//  Created by Бондик Киричков on 26.07.13.
//  Copyright (c) 2013 Kirichkov's. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PullRefreshTableViewController.h"  

@interface InstagramUserFeed : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong) NSString * accessToken;
@property (weak) PullRefreshTableViewController * display;

-(void)refreshFeed;
-(void)getOlderMedia;
@end

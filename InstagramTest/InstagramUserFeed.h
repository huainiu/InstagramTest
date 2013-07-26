//
//  InstagramUserFeed.h
//  InstagramTest
//
//  Created by Бондик Киричков on 26.07.13.
//  Copyright (c) 2013 Kirichkov's. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramUserFeed : NSObject <UITableViewDataSource>

@property (strong) NSString * accessToken;
-(void)requestFeed;
@end
